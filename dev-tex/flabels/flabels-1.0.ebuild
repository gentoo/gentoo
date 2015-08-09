# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit latex-package

DESCRIPTION="Macros for typesetting pretty lables (optionally colored) for the back of files or binders"
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/flabels.html"
# downloaded from:
# ftp.ctan.org/tex-archive/help/Catalogue/entries/flabels.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}
DOCS="README"

src_prepare() {
	chmod +x makedoc
}

src_compile() {
	latex-package_src_compile
	./makedoc
}
