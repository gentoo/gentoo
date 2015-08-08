# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: server part for MediaMVP device"
HOMEPAGE="http://www.loggytronic.com/vomp.php"
SRC_URI="http://www.loggytronic.com/dl/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6"
RDEPEND="${DEPEND}"

PATCHES=("${FILESDIR}/rrprocstart.patch")

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i "s:vompserver:vomp:" vompserver.c
	sed -i "s:char b:// char b:" mediafile.c

	if has_version ">=media-video/vdr-1.7.27"; then
		epatch "${FILESDIR}/vdr-1.7.27.diff"
	fi
}

src_install() {
	vdr-plugin-2_src_install

	dodoc README

	insinto /etc/vdr/plugins/vomp
	newins vomp.conf.sample vomp.conf
	newins vomp-00-00-00-00-00-00.conf.sample vomp-00-00-00-00-00-00.conf
}

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	echo
	elog "Have a look to the VOMP sample files in /etc/vdr/plugins."
	echo
	elog "You have to download the dongle file (i.e. firmware) and adapt"
	elog "the vomp configuration files accordingly."
	echo
}
