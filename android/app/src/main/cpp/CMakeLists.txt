cmake_minimum_required(VERSION 3.10.4)

set(OpenCV_DIR "C:/opencv/OpenCV-android-sdk/sdk/native/jni")
find_package(OpenCV REQUIRED)

add_library(
        native-lib
        SHARED
        native-lib.cpp)

find_library(log-lib log)
include_directories(${OpenCV_INCLUDE_DIRS})

target_link_libraries(
        native-lib
        ${log-lib}
        ${OpenCV_LIBS})