# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit latex-package

MY_P=${PN/latex-/}${PV//./}

DESCRIPTION="LaTeX package for American Astronomical Society journals. (AASTeX)"
HOMEPAGE="http://journals.aas.org/authors/aastex.html"
SRC_URI="http://www.journals.uchicago.edu/AAS/AASTeX/${MY_P}.tar.gz"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc sparc x86"
IUSE=""
S=${WORKDIR}/${MY_P}

src_install() {
	export VARTEXFONTS="${T}/fonts"
	latex-package_src_install
}
