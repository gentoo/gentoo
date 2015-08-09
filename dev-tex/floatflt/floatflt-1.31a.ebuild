# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit latex-package

DESCRIPTION="LaTeX package used to warp text around figures"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/floatflt/"
# http://www.ctan.org/tex-archive/macros/latex/contrib/floatflt.zip
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~amd64 hppa ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

TEXMF="/usr/share/texmf-site"

S=${WORKDIR}/${PN}
DOCS="README"
