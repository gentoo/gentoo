# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A set of python bindings for keyutils"
HOMEPAGE="https://github.com/sassoftware/python-keyutils/"
SRC_URI="https://github.com/sassoftware/python-keyutils/archive/refs/tags/${PV}.tar.gz -> python-keyutils-${PV}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
DEPEND="sys-apps/keyutils"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

S="${WORKDIR}/python-keyutils-${PV}"

src_prepare() {
	default
	sed -i -e '/pytest-runner/d' setup.py || die
	rm keyutils/_keyutils.c || die
}

python_test() {
	ln -s "${S}"/test "${BUILD_DIR}"/test || die
	cd "${BUILD_DIR}" || die
	distutils-r1_python_test
}
