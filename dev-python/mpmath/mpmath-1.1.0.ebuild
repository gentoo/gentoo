# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 eutils virtualx

DESCRIPTION="Python library for arbitrary-precision floating-point arithmetic"
HOMEPAGE="http://mpmath.org/"
SRC_URI="https://github.com/fredrik-johansson/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="gmp matplotlib test"
RESTRICT="!test? ( test )"

RDEPEND="
	gmp? ( dev-python/gmpy )
	matplotlib? ( dev-python/matplotlib[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/${PN}-1.0.0.patch"
	)

	distutils-r1_python_prepare_all
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	pushd ${PN}/tests >/dev/null
	${EPYTHON} runtests.py -local || die "Tests failed with ${EPYTHON}"
	popd >/dev/null
}
