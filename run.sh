docker build -t videocapturewrap .

xhost +local:docker
docker run --rm \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix/:/tmp/.X11-unix \
-v $(pwd):/work \
--device=/dev/video0:/dev/video0 \
-w /work \
videocapturewrap \
bash -c "make run gui"
xhost -local:docker