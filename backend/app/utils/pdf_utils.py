from pypdf import PdfReader, PdfWriter
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.colors import HexColor


FONT_PATH = "fonts/NotoSansBengali-Regular.ttf"


def extract_pdf_text(path: str) -> str:
    reader = PdfReader(path)
    return "\n".join(page.extract_text() or "" for page in reader.pages)


def create_pdf_from_text(text: str, output_path: str) -> None:
    # If the Bengali font exists, register it for Unicode/Bangla output.
    font_name = "Helvetica"
    try:
        pdfmetrics.registerFont(TTFont("NotoBengali", FONT_PATH))
        font_name = "NotoBengali"
    except Exception:
        pass

    c = canvas.Canvas(output_path, pagesize=A4)
    width, height = A4
    y = height - 50
    c.setFont(font_name, 12)

    for line in text.splitlines():
        if y < 50:
            c.showPage()
            c.setFont(font_name, 12)
            y = height - 50

        c.drawString(40, y, line[:110])
        y -= 18

    c.save()


def apply_watermark(
    input_path: str,
    output_path: str,
    text: str,
    position: str,
    opacity: float,
    color: str,
) -> None:
    reader = PdfReader(input_path)
    writer = PdfWriter()

    for page in reader.pages:
        width = float(page.mediabox.width)
        height = float(page.mediabox.height)

        overlay_path = output_path + ".overlay.pdf"
        c = canvas.Canvas(overlay_path, pagesize=(width, height))
        c.setFillColor(HexColor(color))
        c.setFillAlpha(opacity)
        c.setFont("Helvetica", 28)

        margin = 40
        text_width = c.stringWidth(text, "Helvetica", 28)

        positions = {
            "top-left": (margin, height - margin),
            "top-center": ((width - text_width) / 2, height - margin),
            "top-right": (width - text_width - margin, height - margin),
            "center": ((width - text_width) / 2, height / 2),
            "bottom-left": (margin, margin),
            "bottom-center": ((width - text_width) / 2, margin),
            "bottom-right": (width - text_width - margin, margin),
        }

        x, y = positions[position]
        c.drawString(x, y, text)
        c.save()

        overlay = PdfReader(overlay_path).pages[0]
        page.merge_page(overlay)
        writer.add_page(page)

        os.remove(overlay_path)

    with open(output_path, "wb") as f:
        writer.write(f)
