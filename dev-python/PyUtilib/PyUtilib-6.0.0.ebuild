# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="A collection of Python utilities"
HOMEPAGE="https://github.com/PyUtilib/pyutilib"
SRC_URI="https://github.com/${PN}/${PN,,}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN,,}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/PyUtilib-6.0.0-tests.patch"
)

distutils_enable_tests unittest

python_install_all() {
	distutils-r1_python_install_all

	find "${ED}" -name '*.pth' -delete || die
}

python_test() {
	distutils_install_for_testing --via-root

	local -x PYTHONPATH="${PWD}:${TEST_DIR}/lib" \
		COLUMNS=80

	eunittest
}
