from fastapi import FastAPI
from app.routes.pdf_routes import router

app = FastAPI(
    title="PDF Editor API",
    description="PDF Translation and Watermark APIs",
    version="1.0.0",
)

app.include_router(router)


@app.get("/")
def root():
    return {"message": "PDF Editor API is running"}
