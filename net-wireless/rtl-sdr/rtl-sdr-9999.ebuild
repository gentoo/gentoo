# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/rtl-sdr/rtl-sdr-9999.ebuild,v 1.9 2015/03/21 20:15:48 zerochaos Exp $

EAPI=5

inherit cmake-utils multilib

DESCRIPTION="turns your Realtek RTL2832 based DVB dongle into a SDR receiver"
HOMEPAGE="http://sdr.osmocom.org/trac/wiki/rtl-sdr"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://git.osmocom.org/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://dev.gentoo.org/~zerochaos/distfiles/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_configure() {
	#the udev rules are 666, we don't want that
	mycmakeargs=(
		-DINSTALL_UDEV_RULES=OFF
		-DDETACH_KERNEL_DRIVER=ON
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	elog "Only users in the usb group can capture."
	elog "Just run 'gpasswd -a <USER> usb', then have <USER> re-login."
}
