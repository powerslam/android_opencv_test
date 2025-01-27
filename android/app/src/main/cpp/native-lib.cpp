#include <jni.h>
#include <string>
#include "calculator.cpp"
#include <jni.h>

extern "C" JNIEXPORT jint JNICALL
Java_com_example_android_1opencv_1test_MainActivity_addition(
        JNIEnv *env, jobject thiz, jint a, jint b) {

    return addition(a, b);
}

extern "C" JNIEXPORT jint JNICALL
Java_com_example_android_1opencv_1test_MainActivity_subtraction(
        JNIEnv *env, jobject thiz, jint a, jint b) {

    return subtraction(a, b);
}


