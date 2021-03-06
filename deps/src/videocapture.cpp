#include <opencv2/opencv.hpp>
#include "jlcxx/jlcxx.hpp"

using namespace jlcxx;
using namespace cv;

// It is not used for our demo. but useful as an yet another example.
int capture_image(cv::VideoCapture &cap)
{
  if (!cap.isOpened())
    return -1;

  Mat frame, edges;
  namedWindow("edges", WINDOW_AUTOSIZE);
  for (int i = 1; i < 30; i++)
  {
    cap >> frame;
    cvtColor(frame, edges, COLOR_BGR2GRAY);
    GaussianBlur(edges, edges, Size(7, 7), 1.5, 1.5);
    Canny(edges, edges, 0, 30, 3);
    imshow("edges", edges);
    if (waitKey(1) >= 0)
      break;
  }
  return 0;
}

// Pass data from C++ to Julia
void set_jlimage(jlcxx::ArrayRef<uint8_t> jlvec, cv::Mat& frame)
{
  cv::cvtColor(frame, frame, COLOR_BGR2RGB);
  int H = frame.rows;
  int W = frame.cols;
  int idx = 0;
  for (int j = 0; j < W; j++)
  {
    for (int i = 0; i < H; i++)
    {
      for (int k = 0; k < 3; k++)
      {
        jlvec[idx] = frame.ptr<cv::Vec3b>(i)[j][k];
        idx++;
      }
    }
  }
}

// Pass data from Julia to C++
cv::Mat to_cvimage(jlcxx::ArrayRef<uint8_t> jlimg, int C, int H, int W)
{
  cv::Mat frame(H, W, CV_8UC(C));
  int idx = 0;
  for (int j = 0; j < W; j++)
  {
    for (int i = 0; i < H; i++)
    {
      for (int k = 0; k < 3; k++)
      {
        frame.ptr<cv::Vec3b>(i)[j][k]= jlimg[idx];
        idx++;
      }
    }
  }
  cv::cvtColor(frame, frame, COLOR_BGR2RGB);
  return frame;
}

double get_capture_width(cv::VideoCapture &cap)
{
  return cap.get(CAP_PROP_FRAME_WIDTH);
}

double get_capture_height(cv::VideoCapture &cap)
{
  return cap.get(CAP_PROP_FRAME_HEIGHT);
}

JLCXX_MODULE
define_videoio_module(Module &mod)
{
  mod.add_type<cv::Mat>("Mat")
      .constructor<int, int, int>();
  //mod.add_type<cv::String>("CVString"); // remove this if you are mac user

  mod.set_override_module(mod.julia_module());
  mod.add_type<cv::VideoCapture>("VideoCapture")
      .constructor<int>()
      .method(
          "isOpened",
          [](const cv::VideoCapture &instance) { return instance.isOpened(); })
      .method("release",
              [](cv::VideoCapture &instance) { return instance.release(); })
      .method("read",
              [](cv::VideoCapture &instance) {
                Mat frame;
                instance.read(frame);
                return frame;
              })
      .method("read!",
              [](cv::VideoCapture &instance, cv::Mat &frame) {
                instance.read(frame);
                return frame;
              });
  mod.unset_override_module();

  mod.method("namedWindow", [](const std::string &winname, int mode){
    cv::namedWindow(winname, mode);
  });
  mod.method("waitKey", cv::waitKey);
  mod.method("destroyWindow", [](const std::string &winname){
    cv::destroyWindow(winname);
  });
  mod.method("imshow", [](const std::string &winname, const cv::Mat &mat) {
    return cv::imshow(winname, cv::InputArray(mat));
  });

  mod.method("capture_image", capture_image);
  mod.method("get_capture_width", get_capture_width);
  mod.method("get_capture_height", get_capture_height);
  mod.method("set_jlimage!", set_jlimage);
  mod.method("to_cvimage", to_cvimage);
}
