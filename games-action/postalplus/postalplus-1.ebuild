# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/postalplus/postalplus-1.ebuild,v 1.6 2015/03/30 21:45:32 mr_bones_ Exp $

EAPI=5
inherit eutils cdrom games

DESCRIPTION="Ultraviolent and controversial game featuring the Postal Dude"
HOMEPAGE="http://www.lokigames.com/products/postal/"
SRC_URI=""

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="strip"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	cdrom_get_cds postal_plus.ini
	exeinto "${dir}"
	doexe "${CDROM_ROOT}"/bin/x86/postal
	insinto "${dir}"
	doins "${CDROM_ROOT}"/{icon.{bmp,xpm},postal_plus.ini,README}
	cp "${CDROM_ROOT}"/icon.xpm ${PN}.xpm || die

	cp -r "${CDROM_ROOT}"/res "${D}${dir}" || die
	find "${D}" -name TRANS.TBL -exec rm '{}' +

	games_make_wrapper ${PN} ./postal "${dir}"
	doicon ${PN}.xpm
	make_desktop_entry ${PN} "Postal Plus" ${PN}

	prepgamesdirs
}
