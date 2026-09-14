import os


class Settings:
    APP_NAME = "PDF Editor API"
    VERSION = "1.0.0"

    # config.py এখানে: backend/app/config.py
    BASE_DIR = os.path.dirname(os.path.abspath(__file__))    # → backend/app
    PROJECT_ROOT = os.path.dirname(BASE_DIR)                  # → backend

    # static (non-variable) font ব্যবহার করা হচ্ছে, কারণ PyMuPDF variable font ঠিকমতো handle করতে পারে না
    FONT_PATH = os.path.join(
        PROJECT_ROOT, "fonts", "NotoSansBengali-Regular.ttf"
    )
    BANGLA_FONT_NAME = "NotoSansBengali"

    OUTPUT_DIR = os.path.join(PROJECT_ROOT, "temp_outputs")


settings = Settings()

FONT_PATH = settings.FONT_PATH
BANGLA_FONT_NAME = settings.BANGLA_FONT_NAME
OUTPUT_DIR = settings.OUTPUT_DIR

os.makedirs(OUTPUT_DIR, exist_ok=True)

print(f"📁 Font path: {FONT_PATH}")
print(f"📁 Font exists: {os.path.exists(FONT_PATH)}")
print(f"📁 Output dir: {OUTPUT_DIR}")