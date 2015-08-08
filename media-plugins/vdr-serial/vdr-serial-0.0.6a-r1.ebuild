# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: attach some buttons with diodes to the serial port"
HOMEPAGE="http://www.lf-klueber.de/vdr.htm"
SRC_URI="http://www.lf-klueber.de/${P}.tgz
		mirror://vdrfiles/${PN}/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6"

pkg_setup() {
	vdr-plugin-2_pkg_setup

	if ! getent group uucp | grep -q vdr; then
		echo
		einfo "Add user 'vdr' to group 'uucp' for full user access to serial/ttyS* device"
		echo
		elog "User vdr added to group uucp"
		gpasswd -a vdr uucp
	fi
}

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i serial.c -e "s:RegisterI18n://RegisterI18n:"

	cd "${S}"/tools
	emake clean
}
