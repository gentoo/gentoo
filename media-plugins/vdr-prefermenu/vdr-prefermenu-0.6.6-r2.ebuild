# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-prefermenu/vdr-prefermenu-0.6.6-r2.ebuild,v 1.2 2014/06/22 11:31:09 hd_brummy Exp $

EAPI="5"

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: presents a favourites channels menu"
HOMEPAGE="http://www.olivierjacques.com/vdr/prefermenu/"
SRC_URI="http://famillejacques.free.fr/vdr/prefermenu/vdr-${VDRPLUGIN}-${PV}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-2.0"

PATCHES=("${FILESDIR}/${P}-no-static-getfont.diff")

src_prepare() {
	cp "${FILESDIR}/${VDRPLUGIN}.mk" Makefile

	vdr-plugin-2_src_prepare

	sed -e "s:RegisterI18n://RegisterI18n:" -i prefermenu.c
}

src_install() {
	vdr-plugin-2_src_install

	touch prefermenu.conf

	insopts -m0644 -gvdr -ovdr
	insinto /etc/vdr/plugins/prefermenu
	doins prefermenu.conf
}
