# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Zstandard Bindings for Python"
HOMEPAGE="https://pypi.org/project/zstandard/ https://github.com/indygreg/python-zstandard"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=dev-python/cffi-1.14.0-r2:=[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"

distutils_enable_tests setup.py

python_compile() {
	local MAKEOPTS=-j1
	distutils-r1_python_compile
}
