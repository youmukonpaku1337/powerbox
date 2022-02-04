HOSTARCH=$(uname -m)
echo $HOSTARCH

#clean up leftovers
rm powerbox-$HOSTARCH.tar.gz

#create workdir
mkdir alpine

#download and unpack an alpine chroot
curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/$HOSTARCH/alpine-minirootfs-3.15.0-$HOSTARCH.tar.gz
tar -xvf alpine-minirootfs-3.15.0-$HOSTARCH.tar.gz -C ./alpine/

#chroot
doas chroot ./alpine /bin/sh<<"EOT"

#set PATH
source /etc/profile

#internet magik
addgroup -g 3003 -S inet
addgroup root inet
adduser -s /bin/zsh -g inet powerbox

#add DNS
rm /etc/resolv.conf
echo "nameserver 8.8.8.8" > /etc/resolv.conf

#install the packages
apk add nnn micro vim nano bat curl wget nim github-cli git alpine-base doas zsh shadow bash openssh gcc alpine-sdk mpv

#configure doas
echo "permit powerbox">/etc/doas.d/doas.conf
echo "permit nopass root">/etc/doas.d/doas.conf

#openrc magik
mkdir -p /home/powerbox/git
mkdir /home/powerbox/downloads
mkdir -p /run/openrc/
mkdir -p /lib64/rc/init.d/

#moar openrc magik
ln -s /usr/bin/doas /usr/bin/sudo
ln -s /lib64/rc/init.d /run/openrc

#even moar openrc magik
touch /run/openrc/softlevel

#install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/powerbox/git/powerlevel10k
echo 'source /home/powerbox/git/powerlevel10k/powerlevel10k.zsh-theme' >>/home/powerbox/.zshrc

#change the owner of /home/powerbox to the powerbox user
chown -R powerbox /home/powerbox

#set passwords
echo "powerbox:powerbox" | chpasswd
echo "root:powerbox" | chpasswd
EOT

doas /bin/sh<<"EOT"
HOSTARCH=$(uname -m)

#copy over the profile
cp ./profile ./alpine/etc/

#pack the chroot up
tar -zcvf powerbox-$HOSTARCH.tar.gz -C ./alpine .

#clean up
rm -rf ./alpine
rm alpine-minirootfs-3.15.0-$HOSTARCH.tar.gz
EOT
