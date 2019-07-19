# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit latex-package

S="${WORKDIR}/${PN}"
LICENSE="LPPL-1.2"
DESCRIPTION="A LaTeX module to acces RCS/CVS version info"
HOMEPAGE="http://www.ctan.org/pkg/rcsinfo"
# downloaded from
# http://mirrors.ctan.org/macros/latex/contrib/rcsinfo.zip
SRC_URI="mirror://gentoo/${P}.zip"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS="README-1.9 README"
RDEPEND=""
DEPEND="dev-tex/latex2html
	app-arch/unzip"
