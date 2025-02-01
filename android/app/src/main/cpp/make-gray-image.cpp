#include <random>
#include <opencv2/opencv.hpp>

cv::Mat makeGrayImage() {
    std::random_device rd;
    std::mt19937 gen(rd());

    std::uniform_int_distribution<int> dis(0, 255);

    return cv::Mat(128, 128, CV_8UC1, cv::Scalar(dis(gen)));
}
