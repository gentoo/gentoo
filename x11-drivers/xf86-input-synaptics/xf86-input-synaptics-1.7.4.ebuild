# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit linux-info xorg-2

DESCRIPTION="Driver for Synaptics touchpads"
HOMEPAGE="https://cgit.freedesktop.org/xorg/driver/xf86-input-synaptics/"

KEYWORDS="amd64 arm ~mips ppc ppc64 x86"
IUSE=""

RDEPEND="sys-libs/mtdev
	>=x11-base/xorg-server-1.12
	>=x11-libs/libXi-1.2
	>=x11-libs/libXtst-1.1.0"
DEPEND="${RDEPEND}
	>=sys-kernel/linux-headers-2.6.37
	>=x11-proto/inputproto-2.1.99.3
	>=x11-proto/recordproto-1.14"

DOCS=( "README" )

PATCHES=(
	"${FILESDIR}"/${PN}-1.7-glibc-2.20.patch
)

pkg_pretend() {
	linux-info_pkg_setup
	# Just a friendly warning
	if ! linux_config_exists \
			|| ! linux_chkconfig_present INPUT_EVDEV; then
		echo
		ewarn "This driver requires event interface support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Input device support --->"
		ewarn "      <*>     Event interface"
		echo
	fi
}
