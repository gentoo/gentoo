# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CDROM_OPTIONAL="yes"
inherit eutils cdrom games

GOG_FILE="gog_duke_nukem_3d_1.0.0.7.tar.gz"
DESCRIPTION="Duke Nukem 3D data files"
HOMEPAGE="http://www.3drealms.com/"
SRC_URI="gog? ( ${GOG_FILE} )"

LICENSE="DUKE3D gog? ( GOG-EULA )"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="gog"
REQUIRED_USE="^^ ( cdinstall gog )"
RESTRICT="mirror bindist gog? ( fetch )"

RDEPEND="|| ( games-fps/eduke32 games-fps/duke3d )"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please download ${GOG_FILE} from your GOG.com account after buying Duke Nukem 3d"
	einfo "and put it into ${DISTDIR}."
}

src_unpack() {
	if use cdinstall ; then
		export CDROM_NAME_SET=(
			"Existing Install"
			"Duke Nukem 3D CD"
			"Duke Nukem 3D Atomic Edition CD"
			)
		cdrom_get_cds duke3d.grp:dvd/dn3dinst/duke3d.grp:atominst/duke3d.grp

		if [[ ${CDROM_SET} -ne 0
			&& ${CDROM_SET} -ne 1
			&& ${CDROM_SET} -ne 2 ]]
		then
			die "Error locating data files.";
		fi
	else
		unpack "${GOG_FILE}"
		cd "Duke Nukem 3D/data" || die

		# convert to lowercase
		find . -type f \
			-execdir sh -c 'echo "converting ${1} to lowercase"
			lower="`echo "${1}" | tr [:upper:] [:lower:]`"
			[ "${1}" = "${lower}" ] || mv "${1}" "${lower}"' - {} \;
	fi
}

src_install() {
	local DATAROOT

	insinto "${GAMES_DATADIR}"/duke3d

	if use cdinstall ; then
		case ${CDROM_SET} in
		0) DATAROOT="" ;;
		1) DATAROOT="dn3dinst/" ;;
		2) DATAROOT="atominst/" ;;
		esac

		# avoid double slash
		doins "${CDROM_ROOT}"/${DATAROOT}{duke3d.grp,duke.rts,game.con,user.con,demo?.dmo,defs.con}
	else
		doins "Duke Nukem 3D/data"/{duke3d.grp,duke.rts,game.con,user.con,demo?.dmo,defs.con}
	fi

	prepgamesdirs
}
