# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_rs 3 '-')

inherit optfeature

DESCRIPTION="The CLI inxi collects and prints hardware and system information"
HOMEPAGE="https://codeberg.org/smxi/inxi"
SRC_URI="https://codeberg.org/smxi/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="dev-lang/perl
	sys-apps/pciutils
	"

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README.txt
}

pkg_postinst() {
	# All packages are in the same order as displayed by inxi --recommends
	# including duplicates in order to keep track of changes in the future.
	optfeature_header "Optional features as suggested by inxi --recommends:"

	optfeature "blockdev: --admin -p/-P (filesystem blocksize)" sys-apps/util-linux
	optfeature "bt-adapter: -E bluetooth data (if no hciconfig, btmgmt)" net-wireless/bluez-tools
	optfeature "btmgmt: -E bluetooth data (if no hciconfig)" net-wireless/bluez
	optfeature "dig: -i wlan IP" net-dns/bind-tools
	optfeature "dmidecode: -M if no sys machine data; -m" sys-apps/dmidecode
	optfeature "doas: -Dx hddtemp-user; -o file-user (alt for sudo)" app-admin/doas
	optfeature "fdisk: -D partition scheme (fallback)" sys-apps/util-linux

	# currently implicit dependency:
	# optfeature "file: -o unmounted file system (if no lsblk)" sys-apps/file
	# not packaged yet:
	# fruid_print: -M machine data, Elbrus only

	optfeature "hciconfig: -E bluetooth data (deprecated, good report)" net-wireless/bluez
	optfeature "hddtemp: -Dx show hdd temp, if no drivetemp module" app-admin/hddtemp
	optfeature "ifconfig: -i ip LAN (deprecated)" sys-apps/net-tools
	optfeature "ip: -i ip LAN" sys-apps/iproute2
	optfeature "ipmitool: -s IPMI sensors (servers)" sys-apps/ipmitool
	optfeature "ipmi-sensors: -s IPMI sensors (servers)" sys-libs/freeipmi
	optfeature "lsblk: -L LUKS/bcache; -o unmounted file system (best option)" sys-apps/util-linux
	optfeature "lsusb: -A usb audio; -J (optional); -N usb networking" sys-apps/usbutils
	optfeature "lvs: -L LVM data" sys-fs/lvm2
	optfeature "mdadm: -Ra advanced mdraid data" sys-fs/mdadm
	optfeature "modinfo: Ax; -Nx module version" sys-apps/kmod
	optfeature "runlevel: -I fallback to Perl" sys-apps/sysvinit
	optfeature "sensors: -s sensors output (optional, /sys supplies most)" sys-apps/lm-sensors
	optfeature "smartctl: -Da advanced data" sys-apps/smartmontools
	# TODO optfeature "strings: -I sysvinit version" sys-devel/llvm-toolchain-symlinks
	optfeature "sudo: -Dx hddtemp-user; -o file-user (try doas!)" app-admin/sudo
	optfeature "tree: --debugger 20,21 /sys tree" app-text/tree
	optfeature "udevadm: -m ram data for non-root, or no dmidecode" sys-apps/systemd
	optfeature "upower: -sx attached device battery info" sys-power/upower
	optfeature "uptime: -I uptime" sys-process/procps
	optfeature "eglinfo: -G X11/Wayland EGL info" x11-apps/mesa-progs
	optfeature "glxinfo: -G X11 GLX info" x11-apps/mesa-progs
	optfeature "vulkaninfo: -G Vulkan API info" dev-util/vulkan-tools
	optfeature "wayland-info: -G Wayland data (not for X)" app-misc/wayland-utils
	optfeature "wmctrl: -S active window manager (fallback)" x11-misc/wmctrl
	optfeature "xdpyinfo: -G (X) Screen resolution, dpi; -Ga Screen size" x11-apps/xdpyinfo
	optfeature "xprop: -S (X) desktop data" x11-apps/xprop
	optfeature "xdriinfo: -G (X) DRI driver (if missing, fallback to Xorg log)" x11-apps/xdriinfo
	optfeature "xrandr: -G (X) monitors(s) resolution; -Ga monitor data" x11-apps/xrandr
}
