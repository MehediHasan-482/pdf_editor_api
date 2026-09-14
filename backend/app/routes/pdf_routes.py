from fastapi import APIRouter, File, Form, UploadFile, HTTPException
from fastapi.responses import FileResponse

from app.services.translate_service import TranslateService
from app.services.watermark_service import WatermarkService

router = APIRouter(tags=["PDF Editor"])

translate_service = TranslateService()
watermark_service = WatermarkService()


@router.post("/api/translate-pdf")
async def translate_pdf(
    file: UploadFile = File(...),
    source_language: str = Form(...),
    target_language: str = Form(...),
):
    try:
        output_path = await translate_service.translate(
            file, source_language, target_language
        )
    except HTTPException:
        raise  # forward validation errors from the service as-is
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unexpected error: {str(e)}")

    return FileResponse(
        output_path,
        media_type="application/pdf",
        filename="translated.pdf",
    )


@router.post("/editor/pdf/watermark")
async def watermark_pdf(
    file: UploadFile = File(...),
    text: str = Form(...),
    position: str = Form(...),
    opacity: float = Form(...),
    color: str = Form(...),
):
    try:
        output_path = await watermark_service.apply(
            file, text, position, opacity, color
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Unexpected error: {str(e)}")

    return FileResponse(
        output_path,
        media_type="application/pdf",
        filename="watermarked.pdf",
    )