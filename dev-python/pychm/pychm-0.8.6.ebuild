# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python bindings for the chmlib library"
HOMEPAGE="https://github.com/dottedmag/pychm"
SRC_URI="https://github.com/dottedmag/pychm/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"

RDEPEND="dev-libs/chmlib"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_test() {
	# need to avoid relative import of 'chm' directory but tests rely
	# on locating files relatively via tests/...
	mv tests .. || die
	cd .. || die
	distutils-r1_src_test
}
