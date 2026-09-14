# PDF Editor API

FastAPI project for the coding assessment.

## Features

- PDF language translation endpoint
- PDF watermark endpoint
- Bangla font support through an embedded TTF font

## Setup

```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

Place `NotoSansBengali-Regular.ttf` inside `fonts/`.

## Run

```bash
uvicorn app.main:app --reload
```

Open Swagger:
`http://127.0.0.1:8000/docs`

## Endpoints

### Translate PDF

`POST /api/translate-pdf`

Multipart fields:
- file
- source_language
- target_language

### Watermark PDF

`POST /editor/pdf/watermark`

Multipart fields:
- file
- text
- position
- opacity
- color
