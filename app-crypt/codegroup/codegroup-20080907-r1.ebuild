# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="encode / decode binary file as five letter codegroups"
HOMEPAGE="https://www.fourmilab.ch/codegroup/"
SRC_URI="https://www.fourmilab.ch/${PN}/${PN}.zip -> ${P}.zip"
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"

BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin ${PN}

	doman ${PN}.1
	dodoc ${PN}.{html,jpg}
}
