# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doomsday-resources/doomsday-resources-1.01-r1.ebuild,v 1.5 2015/01/30 20:23:14 tupone Exp $
EAPI=5
inherit eutils games

DESCRIPTION="Improved models & textures for doomsday"
HOMEPAGE="http://www.doomsdayhq.com/"
SRC_URI="mirror://sourceforge/deng/jdoom-resource-pack-${PV}.zip
	mirror://sourceforge/deng/jdoom-details.zip"

LICENSE="free-noncomm"		#505636
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=games-fps/doomsday-1.9.8"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	insinto "${GAMES_DATADIR}"/doomsday/data/jdoom/auto
	doins data/jDoom/* *.pk3

	# The definitions file cannot be auto-loaded
	insinto "${GAMES_DATADIR}"/doomsday/defs/jdoom
	doins defs/jDoom/*

	dodoc *.txt docs/*
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Add the following to the jdoom/doomsday command-line options:"
	elog "  -def ${GAMES_DATADIR}/doomsday/defs/jdoom/jDRP.ded"
}
