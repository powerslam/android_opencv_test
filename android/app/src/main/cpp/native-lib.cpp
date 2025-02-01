#include <jni.h>
#include <vector>
#include <string>
#include <opencv2/opencv.hpp>

#include "calculator.cpp"
#include "make-gray-image.cpp"

extern "C" JNIEXPORT jint JNICALL
Java_com_example_android_1opencv_1test_MainActivity_addition(
        JNIEnv *env, jobject, jint a, jint b) {

    return addition(a, b);
}

extern "C" JNIEXPORT jint JNICALL
Java_com_example_android_1opencv_1test_MainActivity_subtraction(
        JNIEnv *env, jobject, jint a, jint b) {

    return subtraction(a, b);
}

extern "C" JNIEXPORT jbyteArray JNICALL
Java_com_example_android_1opencv_1test_MainActivity_grayimage(
        JNIEnv *env, jobject){

    cv::Mat grayImage = makeGrayImage();

    std::vector<uchar> outputBuffer;
    cv::imencode(".jpg", grayImage, outputBuffer);

    jbyteArray outputImage = env->NewByteArray(outputBuffer.size());
    env->SetByteArrayRegion(outputImage, 0, outputBuffer.size(), reinterpret_cast<jbyte *>(outputBuffer.data()));

    return outputImage;
}

