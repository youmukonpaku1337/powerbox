HOSTARCH=$(uname -m)
echo $HOSTARCH
rm powerbox-$HOSTARCH.tar.gz
mkdir alpine

curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/$HOSTARCH/alpine-minirootfs-3.15.0-$HOSTARCH.tar.gz
tar -xvf alpine-minirootfs-3.15.0-$HOSTARCH.tar.gz -C ./alpine/

doas chroot ./alpine /bin/sh<<"EOT"
source /etc/profile
addgroup -g 3003 -S inet
addgroup root inet
adduser -s /bin/zsh -g inet powerbox
rm /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apk add bat curl wget nim github-cli git alpine-base doas zsh shadow bash openssh gcc alpine-sdk
mkdir -p /home/powerbox/git
mkdir /home/powerbox/downloads
mkdir -p /run/openrc/
mkdir -p /lib64/rc/init.d/
ln -s /usr/bin/doas /usr/bin/sudo
ln -s /lib64/rc/init.d /run/openrc
touch /run/openrc/softlevel
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/powerbox/git/powerlevel10k
echo 'source /home/powerbox/git/powerlevel10k/powerlevel10k.zsh-theme' >>/home/powerbox/.zshrc
EOT

doas /bin/sh<<"EOT"
HOSTARCH=$(uname -m)
cp ./profile ./alpine/etc/
tar -zcvf powerbox-$HOSTARCH.tar.gz ./alpine
rm -rf ./alpine
rm alpine-minirootfs-3.15.0-$HOSTARCH.tar.gz
EOT
