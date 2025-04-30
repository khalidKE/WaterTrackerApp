buildscript {
    repositories {
        google() // Add this to resolve Google dependencies
        mavenCentral() // Add this for other dependencies
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15") // Ensure this is added
    }
}

allprojects {
    repositories {
        google() // Add this to resolve Google dependencies
        mavenCentral() // Add this for other dependencies
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
