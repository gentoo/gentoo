# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_P=${P/-/-v}
DESCRIPTION="GSD - file format specification and a library to read and write it"
HOMEPAGE="
	https://github.com/glotzerlab/gsd/
	https://pypi.org/project/gsd/
"
SRC_URI="
	https://github.com/glotzerlab/gsd/releases/download/v${PV}/${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-python/numpy-1.23.4[${PYTHON_USEDEP}]
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
