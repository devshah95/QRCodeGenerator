from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import qrcode
from io import BytesIO
from fastapi.responses import StreamingResponse, FileResponse
from fastapi.middleware.cors import CORSMiddleware
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class QRRequest(BaseModel):
    data: str

@app.post("/generate_qr/")
def generate_qr(request: QRRequest):
    qr = qrcode.make(request.data)
    
    file_path = f"{request.data}.png"
    qr.save(file_path)

    return FileResponse(file_path, media_type="image/png", filename=file_path)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="localhost", port=8000)
