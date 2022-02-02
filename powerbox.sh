mount -o rw,remount /
echo "Which directory would you like to install powerbox to? (/linux is recommended): "
read -r powerdir

if [ "$powerdir" == "" ]
then
  powerdir = /linux
fi

mkdir $powerdir
echo "How many gigabytes of space would you like to allocate to the chroot image? (no symbols, in gigabytes): "

read -r powersize 
if [ "$powersize" == "" ]
then
  powersize = 10
fi
powerimgsize = powersize * 1000000 / 16
echo "How would you like to name the image? (linux is recommended): "
read -r powerimgname

if [ "$powerimgname" == "" ]
then
  powerimgname = "linux"
fi

echo "Creating image..."
dd if=/dev/zero of=/sdcard/$powerimgname.img bs=16k count=$powerimgsize
mkfs.ext4 /sdcard/$powerimgname
echo "Downloading archive..."
wget https://duckykutya.cf/kat/powerbox/powerbox.tar.gz
echo "Unpacking archive..."
tar -xvf powerbox.tar.gz -C $powerdir
echo "Downloading alpishell..."
wget https://github.com/egor4ka/alpishell/releases/download/0.1/alpishell
echo "Installing alpishell..."
mv alpishell /system/xbin/alpishell
chmod +x /system/xbin/alpishell
echo "Cleaning up..."
rm powerbox.tar.gz
rm alpishell
echo "Done! Now, just run alpishell and you should be fine, unless you used a different path/.img path, in which case run alpishell -h to get some help."
