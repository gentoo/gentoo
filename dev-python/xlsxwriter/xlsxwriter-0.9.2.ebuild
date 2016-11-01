# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} pypy pypy3 )

inherit distutils-r1

MY_PN="XlsxWriter"
MY_P="${MY_PN}-${PV}"

# PLEASE UPDATE
# for up2date tests. Upstream says they are to large to be shipped to pypi
# https://github.com/jmcnamara/XlsxWriter/issues/327
# https://github.com/jmcnamara/XlsxWriter/issues/229
RELEASE=b24d6fbf38862558f1c114c0c73058ba306d628f

DESCRIPTION="Python module for creating Excel XLSX files"
HOMEPAGE="https://pypi.python.org/pypi/XlsxWriter https://github.com/jmcnamara/XlsxWriter"
SRC_URI="
	mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz
	test? ( https://github.com/jmcnamara/XlsxWriter/archive/${RELEASE}.zip -> ${P}-tests.zip )
	"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	if use test; then
		cp -r "${WORKDIR}"/${MY_PN}-${RELEASE}/${PN}/test ${PN}/ || die
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v -v || die
}
