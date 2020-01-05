# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )

inherit distutils-r1

MY_PN="XlsxWriter"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python module for creating Excel XLSX files"
HOMEPAGE="https://github.com/jmcnamara/XlsxWriter"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz
	test? ( https://github.com/jmcnamara/XlsxWriter/archive/RELEASE_${PV}.zip -> ${P}-tests.zip )

"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( app-arch/unzip
			dev-python/pytest[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_P}

python_prepare_all() {
	if use test; then
		cp -r "${WORKDIR}"/${MY_PN}-RELEASE_${PV}/${PN}/test ${PN}/ || die
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v -v || die
}
