# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-wapd/vdr-wapd-0.9_p1-r1.ebuild,v 1.1 2014/06/21 22:08:34 hd_brummy Exp $

EAPI=5

inherit vdr-plugin-2

MY_P="${PN}-${PV%_p*}"

DESCRIPTION="VDR plugin: lets VDR listen to WAP requests to allow remote control by WML enabled browsers"
HOMEPAGE="http://www.heiligenmann.de/vdr/vdr/plugins/wapd.html"
SRC_URI="http://www.heiligenmann.de/vdr/download/${MY_P}.tgz
	http://www.heiligenmann.de/vdr/download/${MY_P#vdr-}-patch1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=media-video/vdr-1.3.44"

PATCHES=("${FILESDIR}/${MY_P}_gcc-4.1.x.diff"
	"${FILESDIR}/${MY_P}-gentoo.diff"
	"${WORKDIR}/${MY_P#vdr-}-patch1.diff")

S="${WORKDIR}/${MY_P#vdr-}"

src_prepare() {
	cp "${FILESDIR}/wapd.mk" "${S}/Makefile"

	vdr-plugin-2_src_prepare

	sed -e "s:RegisterI18n://RegisterI18n:" -i wapd.c
	remove_i18n_include server.c wapd.c
}

src_install() {
	vdr-plugin-2_src_install

	dobin "${S}/wappasswd"

	insinto /etc/vdr/plugins/wapd
	doins "${FILESDIR}"/{waphosts,wapaccess}
}
