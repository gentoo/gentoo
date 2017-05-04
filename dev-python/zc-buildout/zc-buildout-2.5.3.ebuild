# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} pypy pypy3 )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="System for managing development buildouts"
HOMEPAGE="https://pypi.python.org/pypi/zc.buildout"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

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
	if python_is_python3; then
		ewarn "Tests are broken for ${EPYTHON}, skipping"
		continue
	fi

	distutils_install_for_testing
	"${PYTHON}" src/zc/buildout/tests.py || die "Tests fail with ${EPYTHON}"
}
