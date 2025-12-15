# evalution_yolo_testset.py
# تقييم YOLOv8-Classification على TEST set الرسمي

from ultralytics import YOLO
import os

# مسار مجلد المشروع (TabaatApp)
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

# نفس مجلد الداتا اللي تدرب عليه المودل
data_dir = os.path.join(BASE_DIR, "only_Split_Dataset")

# نجيب آخر run من runs/classify داخل المشروع
runs_dir = os.path.join(BASE_DIR, "runs", "classify")
last_run = sorted(os.listdir(runs_dir))[-1]   # مثلاً train, train2, train3...
run_path = os.path.join(runs_dir, last_run)

# أفضل وزن (best.pt)
weights_path = os.path.join(run_path, "weights", "best.pt")
print(f"Using weights: {weights_path}")

# تحميل المودل
model = YOLO(weights_path)

# تقييم على TEST set
metrics = model.val(
    data=data_dir,
    split="test",   # مهم: test مو val
    imgsz=224
)

print("\nEvaluation done on TEST set.")
print("Top-1 accuracy:", float(metrics.top1))
print("Top-5 accuracy:", float(metrics.top5))
print("All metrics object:\n", metrics)
