# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="A set of python bindings for keyutils"
HOMEPAGE="https://github.com/sassoftware/python-keyutils/"
SRC_URI="https://github.com/sassoftware/python-keyutils/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

DEPEND="sys-apps/keyutils"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest

src_prepare() {
	default
	sed -i -e '/pytest-runner/d' setup.py || die
}

python_test() {
	ln -s "${S}"/test "${BUILD_DIR}"/test || die
	cd "${BUILD_DIR}" || die
	distutils-r1_python_test
}
