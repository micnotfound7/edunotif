plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.edumiccccccccccccccccc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Java 17 required for desugaring
        sourceCompatibility JavaVersion.VERSION_17
                targetCompatibility JavaVersion.VERSION_17

                // Required for flutter_local_notifications and timezone packages
                coreLibraryDesugaringEnabled true
    }

    kotlinOptions {
        // MUST MATCH Java version
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.edumiccccccccccccccccc"
        minSdk = 21    // MUST be 21 or higher for notifications
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Required for flutter_local_notifications + timezone
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.3'
}
