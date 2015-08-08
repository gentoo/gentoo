# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

S=${WORKDIR}/${PN}

DESCRIPTION="LaTeX package used to create foils and slides"
HOMEPAGE="ftp://ftp.dante.de/tex-archive/help/Catalogue/entries/foiltex.html"
# Taken from http://www.ctan.org/get/macros/latex/contrib/foiltex.zip
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="FoilTeX"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

TEXMF=/usr/share/texmf-site
DEPEND="app-arch/unzip"
RDEPEND=""

src_install () {
	latex-package_src_doinstall all
	dodoc "${S}/README"
}
