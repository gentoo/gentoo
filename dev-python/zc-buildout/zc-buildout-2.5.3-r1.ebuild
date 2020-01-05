# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_6 pypy3 )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="System for managing development buildouts"
HOMEPAGE="https://pypi.org/project/zc.buildout/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
# Tests are broken
RESTRICT="test"

RDEPEND=">=dev-python/setuptools-3.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/zope-testing[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_P}

DOCS=( README.rst doc/tutorial.txt )

# Prevent incorrect installation of data file
python_prepare_all() {
	sed -e '/^    include_package_data/d' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	"${PYTHON}" src/zc/buildout/tests.py || die "Tests fail with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	python_moduleinto zc
	python_domodule src/zc/__init__.py
}

python_install_all() {
	distutils-r1_python_install_all

	find "${D}" -name '*.pth' -delete || die
}
