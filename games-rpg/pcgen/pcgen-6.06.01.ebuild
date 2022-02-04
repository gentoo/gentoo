# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop edos2unix

DESCRIPTION="D&D character generator"
HOMEPAGE="http://pcgen.org/"
SRC_URI="https://github.com/PCGen/pcgen/releases/download/${PV}/${P}-full.zip"
S="${WORKDIR}/${PN}"

LICENSE="LGPL-2.1 OGL-1.0a"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

src_prepare() {
	default

	edos2unix ${PN}.sh
	sed "/^cd /c\\cd \"${EPREFIX}/opt/${PN}\" || exit 1" ${PN}.sh > "${T}"/${PN} || die

	rm -r LICENSE docs/{doc_tools,pngcrush_logs.txt} ${PN}.{exe,sh} || die
}

src_install() {
	dobin "${T}"/${PN}

	insinto /opt/${PN}
	doins -r .

	newicon system/sponsors/pcgen/pcgen_128x128.png ${PN}.png
	make_desktop_entry ${PN} PCGen
}
