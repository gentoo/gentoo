# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

DESCRIPTION="vdr Plugin: Shows linux console on vdr's output device"
HOMEPAGE="http://ricomp.de/vdr/"
SRC_URI="http://ricomp.de/vdr/${P}.tgz"

LICENSE="GPL-2"
IUSE=""
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND=">=media-video/vdr-1.6.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-vdr-1.3.18.diff
	"${FILESDIR}"/${P}-uint64.diff )

src_prepare() {
	vdr-plugin-2_src_prepare

	vdr_remove_i18n_include console.c menu.c terminalemulation.c virtualconsole.c virtualconsoles.c
	sed  -i console.c -e "s:RegisterI18n://RegisterI18n:"

	ewarn "plugin will not support the new fonthandling"
	epatch "${FILESDIR}/${P}-vdr-1.6.x-compilefix.diff"
}
