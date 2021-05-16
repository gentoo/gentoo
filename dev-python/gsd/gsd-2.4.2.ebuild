# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

MY_P=${P/-/-v}
DESCRIPTION="GSD - file format specification and a library to read and write it"
HOMEPAGE="https://github.com/glotzerlab/gsd"
SRC_URI="
	https://github.com/glotzerlab/gsd/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND=${DEPEND}
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_test() {
	cd "${BUILD_DIR}"/lib || die
	epytest gsd/test
	rm -rf .pytest_cache .hypothesis || die
}
