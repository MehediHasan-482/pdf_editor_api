import os
import uuid
import asyncio

import fitz  # PyMuPDF
from translatepy import Translator
from fastapi import HTTPException

from app.config import FONT_PATH, BANGLA_FONT_NAME, OUTPUT_DIR

ICON_FONT_KEYWORDS = ["awesome", "icon", "symbol", "wingding", "material"]


class TranslateService:
    def __init__(self):
        self.translator = Translator()

    async def translate(self, file, source_language: str, target_language: str) -> str:
        pdf_bytes = await file.read()

        if not pdf_bytes:
            raise HTTPException(status_code=400, detail="Uploaded file is empty.")
        if not pdf_bytes.startswith(b"%PDF"):
            raise HTTPException(status_code=400, detail="Uploaded file is not a valid PDF.")

        try:
            doc = fitz.open(stream=pdf_bytes, filetype="pdf")
        except Exception as e:
            raise HTTPException(status_code=422, detail=f"Could not open PDF: {e}")

        try:
            await asyncio.to_thread(self._process_doc, doc, source_language, target_language)
        except Exception as e:
            doc.close()
            raise HTTPException(status_code=500, detail=f"Translation failed: {e}")

        output_path = os.path.join(OUTPUT_DIR, f"translated_{uuid.uuid4().hex}.pdf")
        doc.save(output_path)
        doc.close()

        print(f"📄 Output saved: {output_path}")
        return output_path

    def _is_icon_font(self, fontname: str) -> bool:
        name = fontname.lower()
        return any(k in name for k in ICON_FONT_KEYWORDS)

    def _process_doc(self, doc, source: str, target: str):
        for page in doc:
            page.insert_font(fontname=BANGLA_FONT_NAME, fontfile=FONT_PATH)

            blocks = page.get_text("dict")["blocks"]
            redactions = []
            replacements = []

            for block in blocks:
                if block["type"] != 0:
                    continue
                for line in block["lines"]:
                    line_text = "".join(span["text"] for span in line["spans"]).strip()
                    if not line_text:
                        continue
                    if all(self._is_icon_font(s["font"]) for s in line["spans"]):
                        continue

                    bbox = fitz.Rect(line["bbox"])
                    fontsize = line["spans"][0]["size"]
                    translated = self._translate_chunk(line_text, source, target)

                    redactions.append(bbox)
                    replacements.append((bbox, translated, fontsize))

            for bbox in redactions:
                page.add_redact_annot(bbox, fill=(1, 1, 1))
            page.apply_redactions()

            for bbox, translated, fontsize in replacements:
                size = fontsize
                while size > 5:
                    rc = page.insert_textbox(
                        bbox, translated,
                        fontsize=size,
                        fontname=BANGLA_FONT_NAME,
                        fontfile=FONT_PATH,
                        align=0,
                    )
                    if rc >= 0:
                        break
                    size -= 0.5

    def _translate_chunk(self, text: str, source: str, target: str) -> str:
        try:
            result = self.translator.translate(
                text, source_language=source, destination_language=target
            )
            return result.result or text
        except Exception as e:
            print(f"❌ Translation failed for '{text[:30]}...': {e}")
            return text