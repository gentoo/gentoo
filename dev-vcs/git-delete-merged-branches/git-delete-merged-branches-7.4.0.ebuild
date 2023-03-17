# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Command-line tool to delete merged Git branches"
HOMEPAGE="https://github.com/hartwork/git-delete-merged-branches"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="full-name-executable test"

COMMON_DEPEND="
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-3.0.18[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	test? ( dev-python/parameterized[${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	full-name-executable? ( !dev-vcs/git-extras )
	dev-vcs/git
"

RESTRICT="!test? ( test )"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	if ! use full-name-executable; then
	    rm "${D}"/usr/bin/git-delete-merged-branches || die
	    rm "${D}"/usr/share/man/man1/git-delete-merged-branches.1* || die
	fi
}
