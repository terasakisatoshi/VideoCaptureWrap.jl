FROM julia:1.5.3

# Tip1: https://askubuntu.com/questions/342202/failed-to-load-module-canberra-gtk-module-but-already-installed

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libeigen3-dev \
    libopencv-dev \
    libstdc++6 \
    cmake \
    libcanberra-gtk-module libcanberra-gtk3-module # Tip1 \
    && \
    echo "Done"
