# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/wolfgl/wolfgl-0.93-r1.ebuild,v 1.11 2009/02/06 13:44:59 tupone Exp $

EAPI=2
#ECVS_SERVER="wolfgl.cvs.sourceforge.net:/cvsroot/wolfgl"
#ECVS_MODULE="wolfgl"
#inherit cvs
inherit eutils games

DESCRIPTION="Wolfenstein and Spear of Destiny port using OpenGL"
HOMEPAGE="http://wolfgl.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tbz2
	mirror://sourceforge/wolfgl/wolfdata.zip
	mirror://sourceforge/wolfgl/sdmdata.zip"
#	mirror://sourceforge/wolfgl/wolfglx-wl6-${PV}.zip
#	mirror://sourceforge/wolfgl/wolfglx-sod-${PV}.zip

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}
	x11-proto/xproto
	app-arch/unzip"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gcc.patch \
		"${FILESDIR}"/${PV}-sample-rate.patch \
		"${FILESDIR}"/${PV}-sprite.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${PV}-gcc4.patch
}

src_compile() {
	emake -j1 CFLAGS="${CFLAGS}" DATADIR="${GAMES_DATADIR}"/${PN} \
		|| die "emake failed"
}

src_install() {
	newgamesbin linux/SDM/wolfgl wolfgl-sdm || die
	newgamesbin linux/SOD/wolfgl wolfgl-sod || die
	newgamesbin linux/WL1/wolfgl wolfgl-wl1 || die
	newgamesbin linux/WL6/wolfgl wolfgl-wl6 || die
	insinto "${GAMES_DATADIR}"/${PN}
	doins "${WORKDIR}"/*.{sdm,wl1} || die
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "This installed the shareware data files for"
	elog "Wolfenstein 3D and Spear Of Destiny."
	elog "If you wish to play the full versions just"
	elog "copy the data files to ${GAMES_DATADIR}/${PN}/"
}
