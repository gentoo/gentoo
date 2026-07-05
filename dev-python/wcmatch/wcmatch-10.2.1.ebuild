# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

DESCRIPTION="Wildcard/glob file name matcher"
HOMEPAGE="
	https://github.com/facelessuser/wcmatch/
	https://pypi.org/project/wcmatch/
"
SRC_URI="
	https://github.com/facelessuser/wcmatch/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	>=dev-python/bracex-3.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-vcs/git
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_prepare_all() {
	# tests require some files in homedir
	> "${HOME}"/test1.txt || die
	> "${HOME}"/test2.txt || die

	distutils-r1_python_prepare_all
}
