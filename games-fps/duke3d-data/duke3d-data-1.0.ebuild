# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/duke3d-data/duke3d-data-1.0.ebuild,v 1.8 2014/06/01 20:23:51 hasufell Exp $

inherit eutils cdrom games

DESCRIPTION="Duke Nukem 3D data files"
HOMEPAGE="http://www.3drealms.com/"
SRC_URI=""

LICENSE="DUKE3D"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( games-fps/eduke32 games-fps/duke3d )"

S=${WORKDIR}

src_unpack() {
	export CDROM_NAME_SET=("Existing Install" "Duke Nukem 3D CD")
	cdrom_get_cds duke3d.grp:dvd/dn3dinst/duke3d.grp

	if [[ ${CDROM_SET} -ne 0 && ${CDROM_SET} -ne 1 ]] ; then
		die "Error locating data files.";
	fi
}

src_install() {
	local DATAROOT

	case ${CDROM_SET} in
	0) DATAROOT= ;;
	1) DATAROOT="dn3dinst/" ;;
	esac

	insinto "${GAMES_DATADIR}"/duke3d
	doins "${CDROM_ROOT}"/$DATAROOT/{duke3d.grp,duke.rts,game.con,user.con,demo2.dmo,defs.con,demo1.dmo} \
		|| die "doins failed"
	prepgamesdirs
}
