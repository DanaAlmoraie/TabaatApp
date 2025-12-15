from ultralytics import YOLO
import os

# نجيب آخر run من مجلد runs/classify
runs_dir = "/Users/dode86/Desktop/TabaatApp/runs/classify"
last_run = sorted(os.listdir(runs_dir))[-1]
run_path = os.path.join(runs_dir, last_run)
weights_path = os.path.join(run_path, "weights", "best.pt")

print(f"Using weights: {weights_path}")

model = YOLO(weights_path)

NEW_IMAGES_DIR = os.path.join( "new_images")

for fname in os.listdir(NEW_IMAGES_DIR):
    if not fname.lower().endswith((".jpg", ".jpeg", ".png")):
        print(f"Skipped (not image): {fname}")
        continue

    img_path = os.path.join(NEW_IMAGES_DIR, fname)

    results = model.predict(
        source=img_path,
        imgsz=224,
        verbose=False
    )

    r = results[0]
    probs = r.probs

    class_idx = int(probs.top1)
    class_name = model.names[class_idx]
    confidence = float(probs.top1conf)

    print(f"{fname} --> {class_name} ({confidence:.3f})")
