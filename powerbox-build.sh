wget https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/aarch64/alpine-minirootfs-3.15.0-aarch64.tar.gz
mkdir ./alpine
tar -xvf alpine-minirootfs-3.15.0-aarch64.tar.gz -C ./alpine/
chroot ./alpine /bin/sh<<"EOT"
apk add bat curl wget github-cli git alpine-base doas zsh shadow bash openssh gcc alpine-sdk
source /etc/profile
useradd powerbox
groupadd -g 3003 inet
usermod -a -G inet --shell /bin/zsh root
usermod -a -G inet --shell /bin/zsh powerbox
su root
rm /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf
mkdir /home/powerbox/
mkdir /home/powerbox/git
mkdir /home/powerbox/downloads
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/powerbox/git/powerlevel10k
echo 'source /home/powerbox/git/powerlevel10k/powerlevel10k.zsh-theme' >>/home/powerbox/.zshrc
wget https://raw.githubusercontent.com/egor4ka/powerbox/main/profile
mv ./profile /etc/profile
EOT
