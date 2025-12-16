if [ -f /etc/vimrc ] && cmp -s /etc/defaults/etc/vimrc /etc/vimrc
then
    rm /etc/vimrc
fi

if [ -f /etc/virc ] && cmp -s /etc/defaults/etc/virc /etc/virc
then
    rm /etc/virc
fi

