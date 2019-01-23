# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1 eutils

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="http://mpmath.org/"
SRC_URI="https://github.com/fredrik-johansson/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

IUSE="gmp matplotlib test"

RDEPEND="
	gmp? ( dev-python/gmpy )
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${P}.patch"
		)

	# this test requires X
	rm ${PN}/tests/test_visualization.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	pushd ${PN}/tests >/dev/null
	${EPYTHON} runtests.py -local
	popd >/dev/null
}
