# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit rpm xdg

DESCRIPTION="Spanish government certificate request generator"
HOMEPAGE="https://www.sede.fnmt.gob.es/descargas/descarga-software"
SRC_URI="https://descargas.cert.fnmt.es/Linux/${PN}_${PV}.x8664.rpm"
S="${WORKDIR}"

LICENSE="FNMT-RCM"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror bindist" #959572

QA_PREBUILT="*"

src_unpack() {
	:
}

src_install() {
	dodir /
	cd "${ED}" || die
	rpm_src_unpack
	sed -i -e '/Version/d' \
		"${ED}"/usr/share/applications/configuradorfnmt.desktop	|| die
}
