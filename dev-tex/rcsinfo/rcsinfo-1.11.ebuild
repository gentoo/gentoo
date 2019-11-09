# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="A LaTeX module to acces RCS/CVS version info"
HOMEPAGE="https://www.ctan.org/pkg/rcsinfo"
# downloaded from
# http://mirrors.ctan.org/macros/latex/contrib/rcsinfo.zip
SRC_URI="mirror://gentoo/${P}.zip"

KEYWORDS="~amd64 ~x86"

LICENSE="LPPL-1.2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="dev-tex/latex2html
	app-arch/unzip
"

DOCS=( "README-1.9 README" )

S="${WORKDIR}/${PN}"
