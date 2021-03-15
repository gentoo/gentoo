# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1 virtualx

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="https://mpmath.org/"
SRC_URI="https://github.com/fredrik-johansson/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="gmp matplotlib test"
RESTRICT="!test? ( test )"

RDEPEND="
	gmp? ( dev-python/gmpy[${PYTHON_USEDEP}] )
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_configure() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	pushd ${PN}/tests >/dev/null
	${EPYTHON} runtests.py -local || die "Tests failed with ${EPYTHON}"
	popd >/dev/null
}
