# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils cdrom games

DESCRIPTION="Enemy Territory: Quake Wars data files"
HOMEPAGE="http://zerowing.idsoftware.com/linux/etqw/"
SRC_URI=""

LICENSE="ETQW"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="videos"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/etqw

	cdrom_get_cds Setup/Data/base/DEU:Setup/Data/base/POL:Setup/Data/base

	cd "${CDROM_ROOT}"/Setup/Data/base
	insinto "${dir}"/base
	doins pak00{0..4}.pk4 || die "doins pak failed"
	doins -r megatextures || die "doins megatextures failed"

	case ${CDROM_SET} in
		0)
			doins \
				zpak_english000.pk4 \
				DEU/zpak_german000.pk4 \
				ESP/zpak_spanish000.pk4 \
				FRA/zpak_french000.pk4 \
				|| die "doins zpak failed"
			;;
		1)
			doins \
				POL/zpak_polish000.pk4 \
				RUS/zpak_russian000.pk4 \
				|| die "doins zpak failed"
			;;
		2)
			doins zpak_english000.pk4 || die "doins zpak failed"
			;;
	esac

	if use videos ; then
		case ${CDROM_SET} in
			0|2)
				doins -r video || die "doins video failed"
				;;
		esac
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	elog "This is just the data portion of the game. You will need to install"
	elog "games-fps/etqw-bin to play it."
}
