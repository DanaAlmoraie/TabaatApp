from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from ultralytics import YOLO
from pathlib import Path
import tempfile, os

app = FastAPI(title="Tabaat AI API")

# (اختياري لكن مهم لو بتجربين من web)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

MODEL_PATH = "/Users/dode86/Desktop/TabaatApp-1/AIModel/runs/classify/train/weights/best.pt"
model = YOLO(MODEL_PATH)

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if not file:
        return JSONResponse({"error": "No image uploaded"}, status_code=400)

    suffix = os.path.splitext(file.filename)[-1] or ".jpg"
    tmp_path = None

    try:
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
            tmp.write(await file.read())
            tmp_path = tmp.name

        results = model(tmp_path)
        probs = results[0].probs

        top1_idx = int(probs.top1)
        top1_conf = float(probs.top1conf)

        names = results[0].names  # {idx: "class"}
        pred_class = names.get(top1_idx, str(top1_idx))

        # نفس Flask keys
        return {"label": pred_class, "confidence": top1_conf}

    except Exception as e:
        return JSONResponse({"error": str(e)}, status_code=500)

    finally:
        if tmp_path and os.path.exists(tmp_path):
            os.remove(tmp_path)