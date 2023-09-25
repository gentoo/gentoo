# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="GSD - file format specification and a library to read and write it"
HOMEPAGE="
	https://github.com/glotzerlab/gsd/
	https://pypi.org/project/gsd/
"
SRC_URI="
	https://github.com/glotzerlab/gsd/releases/download/v${PV}/${P}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/numpy-1.24.2[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	cd "${T}" || die
	epytest --pyargs gsd
}
