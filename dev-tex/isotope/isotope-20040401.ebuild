# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

DESCRIPTION="Typeset isotopes correctly in LaTeX documents"
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/isotope.html"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/${PN}
