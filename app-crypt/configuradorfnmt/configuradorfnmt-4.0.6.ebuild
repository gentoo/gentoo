# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit rpm xdg

DESCRIPTION="Spanish government certificate request generator"
HOMEPAGE="https://www.sede.fnmt.gob.es/descargas/descarga-software/instalacion-software-generacion-de-claves"
SRC_URI="https://descargas.cert.fnmt.es/Linux/${P}-0.x86_64.rpm"
S="${WORKDIR}"

LICENSE="FNMT-RCM"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror bindist" #959572

RDEPEND="virtual/jre:17"
DEPEND="${RDEPEND}"

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
