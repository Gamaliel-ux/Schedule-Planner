plugins {
    id("com.android.application")
    // Flutter Gradle Plugin harus diterapkan setelah
    // Android dan Kotlin Gradle Plugin.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.schedule_planner"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion

    // ==========================================================
    // JAVA / CORE LIBRARY DESUGARING
    // ==========================================================

    compileOptions {
        // Java 17
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // Required by flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }

    // ==========================================================
    // DEFAULT CONFIG
    // ==========================================================

    defaultConfig {
        applicationId = "com.example.schedule_planner"

        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode

        versionName = flutter.versionName
    }

    // ==========================================================
    // BUILD TYPES
    // ==========================================================

    buildTypes {
        release {
            // Untuk development sementara,
            // gunakan debug signing.
            signingConfig =
                signingConfigs.getByName("debug")
        }
    }
}

// ==========================================================
// KOTLIN
// ==========================================================

kotlin {
    compilerOptions {
        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

// ==========================================================
// CORE LIBRARY DESUGARING
// ==========================================================

dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.5"
    )
}

// ==========================================================
// FLUTTER
// ==========================================================

flutter {
    source = "../.."
}