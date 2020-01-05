# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="A collection of Python utilities"
HOMEPAGE="https://github.com/PyUtilib/pyutilib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/pyutilib-5.6.5-tests.patch"
)

python_prepare() {
	# shells out to run nosetests
	rm pyutilib/dev/tests/test_runtests.py || die
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
	fi
}

python_test() {
	COLUMNS="80" "${EPYTHON}" -W ignore::DeprecationWarning \
		-m unittest discover -v || die
}
