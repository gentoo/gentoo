# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Basic inter-process locks"
HOMEPAGE="https://pypi.org/project/zc.lockfile/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ~ppc64 ~riscv ~sparc x86"

BDEPEND="test? ( dev-python/zope-testing[${PYTHON_USEDEP}] )"

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
