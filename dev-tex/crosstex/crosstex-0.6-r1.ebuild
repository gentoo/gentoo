# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="CrossTeX - object oriented BibTeX replacement"
HOMEPAGE="http://www.cs.cornell.edu/people/egs/crosstex/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="dev-python/ply[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

src_install() {
	# NB: LIBDIR changed from site-packages to avoid installing .xtx
	# files to top site-packages dir
	emake \
		ROOT="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="/lib/crosstex" \
		install

	python_fix_shebang "${ED%/}/usr/bin"
	python_optimize "${ED%/}/usr/lib/crosstex"

	dodoc crosstex.pdf
	if use examples; then
		docinto examples
		dodoc -r tests/.
	fi
}
