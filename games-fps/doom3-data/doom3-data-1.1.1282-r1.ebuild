# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cdrom games

DESCRIPTION="Doom 3 - data portion"
HOMEPAGE="http://www.doom3.com/"
SRC_URI=""

LICENSE="DOOM3"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND="games-fps/doom3"

S=${WORKDIR}

src_install() {
	cdrom_get_cds \
		Setup/Data/base/pak002.pk4 \
		Setup/Data/base/pak000.pk4 \
		Setup/Data/base/pak003.pk4

	insinto "${GAMES_PREFIX_OPT}"/doom3/base

	einfo "Copying files from CD 1..."
	doins "${CDROM_ROOT}"/Setup/Data/base/pak002.pk4

	cdrom_load_next_cd
	einfo "Copying files from CD 2..."
	doins "${CDROM_ROOT}"/Setup/Data/base/pak00{0,1}.pk4

	cdrom_load_next_cd
	einfo "Copying files from CD 3..."
	doins "${CDROM_ROOT}"/Setup/Data/base/pak00{3,4}.pk4

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "This is just the data portion of the game. You will need to install"
	elog "games-fps/doom3 to play the game."
}
