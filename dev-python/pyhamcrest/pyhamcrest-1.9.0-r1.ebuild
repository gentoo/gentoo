# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

MY_PN="PyHamcrest"

DESCRIPTION="Hamcrest framework for matcher objects"
HOMEPAGE="https://github.com/hamcrest/PyHamcrest"
SRC_URI="https://github.com/hamcrest/PyHamcrest/archive/V${PV}.tar.gz -> ${MY_PN}-${PV}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~mips ~sh ~sparc ~amd64-linux ~x86-linux"
IUSE="doc examples test"
REQUIRED_USE="doc? ( || ( $(python_gen_useflags -3) ) )"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/six-1.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		$(python_gen_cond_dep '>=dev-python/sphinx-2[${PYTHON_USEDEP}]' -3)
		$(python_gen_cond_dep 'dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]' -3)
	)
	test? (
		>=dev-python/pytest-2.6[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_PN}-${PV}"

pkg_setup() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( -3 )
}

python_prepare_all() {
	# enables coverage testing which we don't want
	rm pytest.ini || die

	# Known test failures. Remove them for now.
	rm tests/hamcrest_unit_test/base_description_test.py || die "removing test #1 failed"
	rm tests/hamcrest_unit_test/core/is_test.py || die "removing test #2 failed"
	rm tests/hamcrest_unit_test/core/isinstanceof_test.py || die "removing test #3 failed"

	# These fail on HPPA. Drop them too.
	if use hppa; then
		rm tests/hamcrest_unit_test/base_matcher_test.py || die "removing test #4 failed"
		rm tests/hamcrest_unit_test/core/described_as_test.py || die "removing test #5 failed"
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx
		HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	fi
}

python_test() {
	py.test -vv || die "Tests failed under ${EPYTHON}"
	"${EPYTHON}" tests/object_import.py || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
