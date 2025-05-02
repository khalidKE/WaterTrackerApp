plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this line
}

android {
    namespace = "com.daily.water_tracker"
    compileSdk = 35 // Updated to 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true // Correct Kotlin DSL syntax
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.daily.water_tracker"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion // Updated to 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // Correct Kotlin DSL syntax
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5") // Updated to 2.1.4
}

flutter {
    source = "../.."
}