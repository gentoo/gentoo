# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit linux-info xorg-2

DESCRIPTION="Generic Linux input driver"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.18[udev]
	dev-libs/libevdev
	sys-libs/mtdev
	virtual/libudev:="
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6
	x11-base/xorg-proto"

pkg_pretend() {
	if use kernel_linux ; then
		CONFIG_CHECK="~INPUT_EVDEV"
	fi
	check_extra_config
}
