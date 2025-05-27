# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A Python library for building configuration shells"
HOMEPAGE="
	https://github.com/open-iscsi/configshell-fb/
	https://pypi.org/project/configshell-fb/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" examples/myshell || die "Test failed with ${EPYTHON}"
}
