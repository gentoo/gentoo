# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake4-data/quake4-data-1.0.2147.12.ebuild,v 1.13 2012/01/16 19:24:33 ulm Exp $

inherit eutils cdrom games

DESCRIPTION="sequel to Quake 2, an id 3D first-person shooter"
HOMEPAGE="http://www.quake4game.com/"
SRC_URI=""

LICENSE="QUAKE4"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="strip"

DEPEND="app-arch/bzip2
	app-arch/tar"
RDEPEND=""
PDEPEND="games-fps/quake4-bin"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/quake4
Ddir=${D}/${dir}

src_install() {
	cdrom_get_cds Setup/Data/q4base/pak012.pk4 \
		Setup/Data/q4base/pak001.pk4 \
		Setup/Data/q4base/pak004.pk4 \
		Setup/Data/q4base/pak007.pk4
	insinto "${dir}"/q4base
	einfo "Copying files from Disk 1..."
	doins "${CDROM_ROOT}"/Setup/Data/q4base/pak01{0,1,2}.pk4 \
		"${CDROM_ROOT}"/Setup/Data/q4base/zpak*.pk4 \
		|| die "copying pak010->pak012 and zpack*"
	cdrom_load_next_cd
	einfo "Copying files from Disk 2..."
	doins "${CDROM_ROOT}"/Setup/Data/q4base/pak00{1,2,3}.pk4 \
		|| die "copying pak001->pak003"
	cdrom_load_next_cd
	einfo "Copying files from Disk 3..."
	doins "${CDROM_ROOT}"/Setup/Data/q4base/pak00{4,5,6}.pk4 \
		|| die "copying pak004->pak006"
	cdrom_load_next_cd
	einfo "Copying files from Disk 4..."
	doins "${CDROM_ROOT}"/Setup/Data/q4base/pak00{7,8,9}.pk4 \
		|| die "copying pak007->pak009"

	find "${Ddir}" -exec touch '{}' +

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "This is just the data portion of the game. You need to merge"
	elog "games-fps/quake4-bin to play."
	echo
}
