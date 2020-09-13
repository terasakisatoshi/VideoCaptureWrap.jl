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
void set_image(jlcxx::ArrayRef<uint8_t> jlimg, cv::VideoCapture cap)
{
  Mat frame;
  cap >> frame;
  cvtColor(frame, frame, COLOR_BGR2RGB);
  int W = cap.get(CAP_PROP_FRAME_WIDTH);
  int H = cap.get(CAP_PROP_FRAME_HEIGHT);
  int idx = 0;
  for (int j = 0; j < W; j++)
  {
    for (int i = 0; i < H; i++)
    {
      for (int k = 0; k < 3; k++)
      {
        jlimg[idx] = frame.ptr<cv::Vec3b>(i)[j][k];
        idx++;
      }
    }
  }
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
      .constructor<int, int, int>()
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

  mod.method("namedWindow", cv::namedWindow);
  mod.method("waitKey", cv::waitKey);
  mod.method("destroyWindow", cv::destroyWindow);
  mod.method("imshow", [](const cv::String &winname, const cv::Mat &mat) {
    return cv::imshow(winname, cv::InputArray(mat));
  });

  mod.method("capture_image", capture_image);
  mod.method("get_capture_width", get_capture_width);
  mod.method("get_capture_height", get_capture_height);
  mod.method("set_image!", set_image);
}
