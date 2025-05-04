if [ -n "$GTK_MODULES" ]; then
    GTK_MODULES="${GTK_MODULES}:appmenu-gtk-module"
else
    GTK_MODULES="appmenu-gtk-module"
fi

if [ -z "$UBUNTU_MENUPROXY" ]; then
    UBUNTU_MENUPROXY=1
fi

export GTK_MODULES
export UBUNTU_MENUPROXY
