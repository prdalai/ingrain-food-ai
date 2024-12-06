# Building an Ingredient Analysis App with Flutter and Google Generative AI: A Complete Guide
![Screenshot 1](https://files.oaiusercontent.com/file-F9MNAxRDGYBspLzKLUYH3n?se=2024-12-06T10%3A09%3A56Z&sp=r&sv=2024-08-04&sr=b&rscc=max-age%3D604800%2C%20immutable%2C%20private&rscd=attachment%3B%20filename%3D15ae6dcb-9b47-4ecd-b2fe-8b3b76555a3d.webp&sig=42nngcnsd/WlxKpF2UZhKpT5C8Xu8LTOaI37cQwXpkI%3D)

## Introduction

Grainsafe is a mobile application built using Flutter and the Gemini API designed for quick and easy ingredient analysis.  By scanning a barcode or entering text, users can instantly receive insights into the safety and composition of food and product ingredients. Grainsafe prioritizes simplicity and real-time functionality without storing user data. This project aims to demonstrate how to integrate generative AI into a Flutter application for practical use.


## Installation

1. **Prerequisites:**
   - Flutter: Latest stable version installed.  [Flutter Installation](https://flutter.dev/docs/get-started/install)
   - Dart: Version 3.0 or higher (comes with Flutter).
   - Google Cloud API Key: Obtain a valid API key for using Google's Gemini API. [Google Cloud Console](https://console.cloud.google.com/)

2. **Clone the repository:**

   ```bash
   git clone <GitHub Repository URL>
   cd Grainsafe
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Configure API Key:**  Replace `"YOUR_API_KEY"` in the appropriate file (likely `main.dart` or a configuration file) with your actual Google Cloud API key.

5. **Create `assets/ingredients.json`:** Create the `assets` folder if it doesn't exist and place a `ingredients.json` file inside with your ingredient database (see "Ingredient Database" section below).  Remember to update the `pubspec.yaml` file to include the assets folder:

   ```yaml
   flutter:
     assets:
       - assets/ingredients.json
   ```


## Usage

1. **Launch the app:** Run the app using `flutter run`.
2. **Select an image:** Use the app's image picker to select an image of a product's ingredient list.
3. **Analyze ingredients:** The app will process the image using Gemini API's OCR capabilities to extract the ingredients.
4. **View results:** The app displays the extracted ingredients categorized as "safe" or "unsafe" based on your `ingredients.json` database.


## Features

*   Real-time ingredient analysis using Gemini API.
*   Simple and intuitive user interface.
*   Image-based ingredient extraction (OCR).
*   Local ingredient database for offline functionality.
*   No user data storage.


## Screenshots

![Screenshot 1](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*AAC55c9gpduuw3eCaT8FWQ.png)



## Contributing

Contributions are welcome! Please see the [CONTRIBUTING.md](CONTRIBUTING.md) file for details.


## License

[Specify your license here, e.g., MIT License](LICENSE)


## Ingredient Database (`ingredients.json`)

This JSON file contains a list of ingredients and their safety status:

```json
{
  "palm oil": "unsafe",
  "refined wheat flour": "unsafe",
  "sugar": "safe",
  "water": "safe",
  "vegetable oil": "safe"
}
```

You can customize this database to include your own ingredients and their respective safety classifications.


##  Further Development

*   **Enhance the Database:** Integrate with an online ingredient database for real-time updates and broader coverage.
*   **Add More Features:**  Implement user authentication, personalized ingredient preferences, barcode scanning, multi-language support, and more robust error handling.
*   **Improve Accuracy:** Explore techniques to improve the accuracy of ingredient extraction from images.


## GitHub Repository

[Flutter-Ingredient Analysis Repository](https://github.com/prdalai/ingrain-food-ai/)


## Hashtags

#FlutterDevelopment #GoogleCloud #GenerativeAI #ProductSafety #AppDevelopment #MobileApps #AIIntegration #GeminiAPI #IngredientAnalysis
