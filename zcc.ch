sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install build-essential pkg-config libgtest-dev libc6-dev m4 autoconf libtool nano htop lm-sensors ncurses-dev unzip git python zlib1g-dev wget bsdmainutils automake aptitude -y
sudo aptitude install g++ g++-multilib -y
rm -rf zcash
rm -rf .zcash
rm -rf .zcash-params
rm -rf .zclassic
rm -rf zclassic
git clone https://github.com/z-classic/zclassic.git
cd zclassic/
echo "now compilation will start"
./zcutil/build.sh -j$(nproc)
echo "Downloading fetch-params"
./zcutil/fetch-params.sh
mkdir -p ~/.zclassic
echo "rpcuser=user" >> ~/.zclassic/zclassic.conf
echo "rpcpassword=`head -c 32 /dev/urandom | base64`" >>~/.zclassic/zclassic.conf
echo "gen=1" >> ~/.zclassic/zclassic.conf
echo "genproclimit=1" >> ~/.zclassic/zclassic.conf
echo "equihashsolver=tromp" >> ~/.zclassic/zclassic.conf
echo "server=1" >> ~/.zclassic/zclassic.conf
echo "listen=1" >> ~/.zclassic/zclassic.conf
echo "now solo mining will start"
cd zclassic
./src/zcashd
