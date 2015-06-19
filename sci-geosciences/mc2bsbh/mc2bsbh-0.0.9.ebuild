# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/mc2bsbh/mc2bsbh-0.0.9.ebuild,v 1.1 2011/06/23 11:32:57 mschiff Exp $

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
