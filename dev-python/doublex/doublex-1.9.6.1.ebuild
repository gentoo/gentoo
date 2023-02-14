# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

MY_P=python-doublex-${PV}
DESCRIPTION="Python test doubles"
HOMEPAGE="
	https://github.com/davidvilla/python-doublex/
	https://pypi.org/project/doublex/
"
SRC_URI="
	https://github.com/davidvilla/python-doublex/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/pyhamcrest[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs --no-autodoc
distutils_enable_tests pytest

src_prepare() {
	sed -i -e '/data_files/d' setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	epytest -o 'python_files=*_tests.py'
}
