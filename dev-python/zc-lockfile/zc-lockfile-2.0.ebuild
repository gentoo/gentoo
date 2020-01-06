# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} pypy3 )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Basic inter-process locks"
HOMEPAGE="https://pypi.org/project/zc.lockfile/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc64 ~sparc"
IUSE="test"

RDEPEND=">=dev-python/setuptools-3.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/zope-testing[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_P}

DOCS=( CHANGES.rst README.rst )

distutils_enable_tests nose

# Prevent incorrect installation of data file
python_prepare_all() {
	sed -e '/^    include_package_data/d' -i setup.py || die
	distutils-r1_python_prepare_all
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
