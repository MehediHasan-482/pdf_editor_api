import os
import uuid

from fastapi import HTTPException, UploadFile

from app.utils.pdf_utils import apply_watermark


ALLOWED_POSITIONS = {
    "top-left",
    "top-center",
    "top-right",
    "center",
    "bottom-left",
    "bottom-center",
    "bottom-right",
}


class WatermarkService:
    async def apply(
        self,
        file: UploadFile,
        text: str,
        position: str,
        opacity: float,
        color: str,
    ) -> str:
        if not file.filename or not file.filename.lower().endswith(".pdf"):
            raise HTTPException(400, "Only PDF files are supported.")

        if not text.strip():
            raise HTTPException(400, "Watermark text is required.")

        if position not in ALLOWED_POSITIONS:
            raise HTTPException(400, "Invalid watermark position.")

        if not 0.0 <= opacity <= 1.0:
            raise HTTPException(400, "Opacity must be between 0.0 and 1.0.")

        if not color.startswith("#") or len(color) != 7:
            raise HTTPException(400, "Color must be a hex value like #FF0000.")

        os.makedirs("temp", exist_ok=True)
        input_path = f"temp/{uuid.uuid4()}_input.pdf"
        output_path = f"temp/{uuid.uuid4()}_watermarked.pdf"

        with open(input_path, "wb") as buffer:
            buffer.write(await file.read())

        apply_watermark(input_path, output_path, text, position, opacity, color)

        os.remove(input_path)
        return output_path
