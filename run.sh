docker build -t videocapturewrap .

xhost +local:docker
docker run --rm \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix/:/tmp/.X11-unix \
-v $(pwd):/work \
--device=/dev/video0:/dev/video0 \
-w /work \
videocapturewrap \
make gui # julia --project=/work callcxx.jl gui
xhost -local:docker