# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="encode / decode binary file as five letter codegroups"
HOMEPAGE="http://www.fourmilab.ch/codegroup/"
SRC_URI="http://www.fourmilab.ch/${PN}/${PN}.zip -> ${P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}
PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}

	doman ${PN}.1
	dodoc ${PN}.{html,jpg}
}
