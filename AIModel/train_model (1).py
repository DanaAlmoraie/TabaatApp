# ======================================
# train_yolo_cls.py
# Train YOLOv8 Classification + plot curves
# ======================================

from ultralytics import YOLO
import pandas as pd
import matplotlib.pyplot as plt
import os

# -------------------------------
# Paths
# -------------------------------
data_dir = "only_Split_Dataset"
model_name = "yolov8n-cls.pt"   
epochs = 20

# -------------------------------
# Train Model
# -------------------------------
model = YOLO(model_name)

results = model.train(
    data=data_dir,
    epochs=epochs,
    imgsz=224,
) 

print("✓ Training done.")
print(f"✓ Run folder: {results.save_dir}")

# -------------------------------
# Read YOLO CSV logs
# -------------------------------
csv_path = os.path.join(results.save_dir, "results.csv")

if not os.path.exists(csv_path):
    raise FileNotFoundError("results.csv not found in YOLO run directory!")

df = pd.read_csv(csv_path)

# -------------------------------
# Plot accuracy
# -------------------------------
plt.figure()
plt.plot(df["train/acc"], label="train_acc")
plt.plot(df["val/acc"], label="val_acc")
plt.xlabel("Epoch")
plt.ylabel("Accuracy")
plt.title("YOLOv8 Classification Accuracy")
plt.legend()
plt.show()

# -------------------------------
# Plot loss
# -------------------------------
plt.figure()
plt.plot(df["train/loss"], label="train_loss")
plt.plot(df["val/loss"], label="val_loss")
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.title("YOLOv8 Classification Loss")
plt.legend()
plt.show()

print("✓ Plots generated successfully!")
