# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="https://github.com/aleaxit/gmpy"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc mpir"

RDEPEND="
	>=dev-libs/mpc-1.0.2
	>=dev-libs/mpfr-3.1.2
	!mpir? ( dev-libs/gmp:0= )
	mpir? ( sci-libs/mpir )"
DEPEND="${RDEPEND}
	app-arch/unzip
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-fix-mpir-types.patch
)

python_prepare_all() {
	# rm non std test file
	rm test*/gmpy_test_thr.py || die
	distutils-r1_python_prepare_all
}

python_configure_all() {
	mydistutilsargs=(
		$(usex mpir --mpir --gmp)
		)
}

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	distutils-r1_python_compile
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd test || die
	"${PYTHON}" runtests.py || die "tests failed under ${EPYTHON}"
	if python_is_python3; then
		cd ../test3 || die
	else
		cd ../test2 || die
	fi
	"${PYTHON}" gmpy_test.py || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
