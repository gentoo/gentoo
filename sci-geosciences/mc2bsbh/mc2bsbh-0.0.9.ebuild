# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit toolchain-funcs

DESCRIPTION="MapCal to BSBchart Header Utility"
HOMEPAGE="http://www.dacust.com/inlandwaters/mapcal/"
SRC_URI="http://www.dacust.com/inlandwaters/mapcal/${PN}/${PN}-beta09.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_compile() {
	$(tc-getCXX) ${LDFLAGS} ${CXXFLAGS} -o ${PN} ${PN}.cpp || die
}

src_install() {
	dobin "${PN}"
}
