# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="LaTeX package used to create foils and slides"
HOMEPAGE="ftp://ftp.dante.de/tex-archive/help/Catalogue/entries/foiltex.html"
# Taken from http://www.ctan.org/get/macros/latex/contrib/foiltex.zip
SRC_URI="mirror://gentoo/${P}.zip"
KEYWORDS="amd64 ppc x86"

LICENSE="FoilTeX"
SLOT="0"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

TEXMF=/usr/share/texmf-site

S=${WORKDIR}/${PN}

src_install () {
	latex-package_src_doinstall all
	dodoc "${S}/README"
}
