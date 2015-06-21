# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/fonttools/fonttools-2.5.ebuild,v 1.1 2015/06/21 08:50:20 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Library for manipulating TrueType, OpenType, AFM and Type1 fonts"
HOMEPAGE="https://github.com/behdad/fonttools/"
SRC_URI="https://github.com/behdad/fonttools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~x86"
IUSE=""

DEPEND=">=dev-python/numpy-1.0.2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	DOCS=( README.md Doc/{changes.txt,install.txt} )
	HTML_DOCS=( Doc/documentation.html )
	distutils-r1_python_install_all
}
