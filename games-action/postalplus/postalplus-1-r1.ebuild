# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cdrom

DESCRIPTION="Ultraviolent and controversial game featuring the Postal Dude"
HOMEPAGE="http://www.lokigames.com/products/postal/"
SRC_URI=""

LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="strip bindist"

S=${WORKDIR}

src_install() {
	local dir=/opt/${PN}

	cdrom_get_cds postal_plus.ini
	exeinto "${dir}"
	doexe "${CDROM_ROOT}"/bin/x86/postal
	insinto "${dir}"
	doins "${CDROM_ROOT}"/{icon.{bmp,xpm},postal_plus.ini,README}
	cp "${CDROM_ROOT}"/icon.xpm ${PN}.xpm || die

	cp -r "${CDROM_ROOT}"/res "${D}${dir}" || die
	find "${D}" -name TRANS.TBL -exec rm '{}' + || die

	make_wrapper ${PN} ./postal "${dir}"
	doicon ${PN}.xpm
	make_desktop_entry ${PN} "Postal Plus" ${PN}
}
