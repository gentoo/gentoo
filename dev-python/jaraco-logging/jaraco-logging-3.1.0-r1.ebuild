# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

MY_PN="${PN/-/.}"
DESCRIPTION="Additional facilities to supplement Python's stdlib logging module"
HOMEPAGE="https://github.com/jaraco/jaraco.logging"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	dev-python/tempora[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	'>=dev-python/jaraco-packaging-3.2' \
	'>=dev-python/rst-linker-1.9'
distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile
	rm "${BUILD_DIR}/install$(python_get_sitedir)"/jaraco/__init__.py || die
}
