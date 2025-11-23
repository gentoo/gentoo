# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Python bindings for the chmlib library"
HOMEPAGE="
	https://github.com/dottedmag/pychm/
	https://pypi.org/project/pychm/
"
SRC_URI="
	https://github.com/dottedmag/pychm/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"

DEPEND="
	dev-libs/chmlib
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest

src_test() {
	# need to avoid relative import of 'chm' directory but tests rely
	# on locating files relatively via tests/...
	mv tests .. || die
	cd .. || die
	distutils-r1_src_test
}
