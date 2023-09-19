# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Shared code for running pylint against rhinstaller projects"
HOMEPAGE="
	https://github.com/rhinstaller/pocketlint/
	https://pypi.org/project/pocketlint/
"
SRC_URI="
	https://github.com/rhinstaller/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pylint[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" tests/pylint/runpylint.py || die "test failed with ${EPYTHON}"
}
