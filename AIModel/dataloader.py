from tensorflow.keras.preprocessing.image import ImageDataGenerator

# عدّلي هذا على حسب مكان فولدر الـ Split_Dataset
DATASET_PATH = r"/Users/dode86/Desktop/TabaatApp/Split_AI_Dataset"

IMAGE_SIZE = (100, 100)
BATCH_SIZE = 32

def load_data():
    train_datagen = ImageDataGenerator(rescale=1./255)
    val_datagen = ImageDataGenerator(rescale=1./255)
    test_datagen = ImageDataGenerator(rescale=1./255)

    train = train_datagen.flow_from_directory(
        DATASET_PATH + "/train",
        target_size=IMAGE_SIZE,
        batch_size=BATCH_SIZE,
        class_mode="categorical"
    )

    val = val_datagen.flow_from_directory(
        DATASET_PATH + "/val",
        target_size=IMAGE_SIZE,
        batch_size=BATCH_SIZE,
        class_mode="categorical"
    )

    test = test_datagen.flow_from_directory(
        DATASET_PATH + "/test",
        target_size=IMAGE_SIZE,
        batch_size=BATCH_SIZE,
        class_mode="categorical"
    )

    return train, val, test

if __name__ == "__main__":
    train, val, test = load_data()

    print("\n--- Dataset Summary ---")
    print(f"Train images: {train.samples}")
    print(f"Val images:   {val.samples}")
    print(f"Test images:  {test.samples}")
    print(f"Classes:      {train.num_classes}")
