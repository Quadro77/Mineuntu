# This did not work
apt  install cmake
sudo bash
git clone https://github.com/xmrig/xmrig-cuda.git
mkdir xmrig-cuda/build && cd xmrig-cuda/build
apt install nvidia-cuda-toolkit (-y? enable confirm)
reboot
sudo apt purge nvidia-cuda-toolkit

