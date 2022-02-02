 hostarch = $(uname -m)
rm ./powerbox-$hostarch.tar.gz
mkdir ./alpine

if [ $hostarch == "aarch64" ]
then
  curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/aarch64/alpine-minirootfs-3.15.0-aarch64.tar.gz
  tar -xvf alpine-minirootfs-3.15.0-aarch64.tar.gz -C ./alpine/
else
  curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/x86_64/alpine-minirootfs-3.15.0-x86_64.tar.gz
  tar -xvf alpine-minirootfs-3.15.0-x86_64.tar.gz -C ./alpine
fi

doas chroot ./alpine /bin/sh<<"EOT"
source /etc/profile
useradd powerbox
groupadd -g 3003 inet
usermod -a -G inet --shell /bin/zsh root
usermod -a -G inet --shell /bin/zsh powerbox
su root
rm /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apk add bat curl wget nim github-cli git alpine-base doas zsh shadow bash openssh gcc alpine-sdk
mkdir -p /home/powerbox/git
mkdir /home/powerbox/downloads
mkdir -p /run/openrc/
mkdir -p /lib64/rc/init.d/
ln -s /lib64/rc/init.d /run/openrc
touch /run/openrc/softlevel
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/powerbox/git/powerlevel10k
echo 'source /home/powerbox/git/powerlevel10k/powerlevel10k.zsh-theme' >>/home/powerbox/.zshrc
EOT

doas /bin/sh<<"EOT"
cp ./profile ./alpine/etc/
tar -zcvf ./powerbox.tar.gz ./alpine
rm -rf ./alpine
EOT
