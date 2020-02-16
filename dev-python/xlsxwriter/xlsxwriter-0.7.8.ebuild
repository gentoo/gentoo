# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 pypy3 )

inherit distutils-r1

MY_PN="XlsxWriter"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python module for creating Excel XLSX files"
HOMEPAGE="https://pypi.org/project/XlsxWriter/ https://github.com/jmcnamara/XlsxWriter"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

S="${WORKDIR}"/${MY_P}

# Missing from tarball
# https://github.com/jmcnamara/XlsxWriter/issues/327
RESTRICT=test

python_test() {
	nosetests --verbosity=3 || die
}
