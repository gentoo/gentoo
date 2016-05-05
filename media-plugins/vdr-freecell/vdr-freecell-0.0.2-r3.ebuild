# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: play 'Freecell' on the On Screen Display"
HOMEPAGE="http://www.magoa.net/linux/index.php?view=freecell"
SRC_URI="http://www.magoa.net/linux/files/${P}.tgz
		mirror://vdrfiles/${PN}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-2"

PATCHES=("${FILESDIR}/${PN}-time_ms.diff"
		"${FILESDIR}/gcc-3.4.patch"
		"${FILESDIR}/${P}-gentoo.diff"
		"${FILESDIR}/${P}_vdr-1.5.4-compile.diff")

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -e "s:RegisterI18n://RegisterI18n:" -i freecell.c
}

src_install() {
	vdr-plugin-2_src_install

	insopts -m0644 -ovdr -gvdr
	insinto /usr/share/vdr/freecell
	doins "${S}/${VDRPLUGIN}"/*
}
