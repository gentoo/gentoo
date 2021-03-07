# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Converts pdf files to odf"
HOMEPAGE="https://sourceforge.net/projects/pdf2oo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-arch/zip
	>=app-text/poppler-0.12.3-r3[utils]
	virtual/imagemagick-tools"

S=${WORKDIR}/${PN}

src_install() {
	dobin pdf2oo
	dodoc README
}
