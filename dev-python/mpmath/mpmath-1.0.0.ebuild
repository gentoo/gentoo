# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1 eutils

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="http://mpmath.org/"
SRC_URI="http://mpmath.org/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE="gmp matplotlib test"
RESTRICT="!test? ( test )"

RDEPEND="
	gmp? ( dev-python/gmpy )
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}.patch"
		)

	# this fails with the current version of dev-python/py
	rm ${PN}/conftest.py || die

	# this test requires X
	rm ${PN}/tests/test_visualization.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die
}
