# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A Python library for building configuration shells"
HOMEPAGE="
	https://github.com/open-iscsi/configshell-fb/
	https://pypi.org/project/configshell-fb/
"
SRC_URI="
	https://github.com/open-iscsi/configshell-fb/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" examples/myshell || die "Test failed with ${EPYTHON}"
}
