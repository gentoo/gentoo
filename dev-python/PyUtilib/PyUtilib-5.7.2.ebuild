# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="A collection of Python utilities"
HOMEPAGE="https://github.com/PyUtilib/pyutilib"
SRC_URI="https://github.com/${PN}/${PN,,}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN,,}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/pyutilib-5.6.5-tests.patch"
)

python_prepare_all() {
	# remove some tests that are completely broken
	rm pyutilib/component/app/tests/test_simple.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing

	local -x PYTHONPATH="${PWD}:${TEST_DIR}/lib" \
		COLUMNS=80

	nosetests -v --with-xunit --xunit-file=TEST-pyutilib.xml pyutilib || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	find "${ED}" -name '*.pth' -delete || die
}

python_install() {
	distutils-r1_python_install

	if ! python_is_python3; then
		printf "# Placeholder for python2\n" \
			> "${D}$(python_get_sitedir)/${PN,,}/__init__.py"

		python_optimize
	fi
}
