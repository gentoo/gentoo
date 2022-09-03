# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Command-line tool to delete merged Git branches"
HOMEPAGE="https://github.com/hartwork/git-delete-merged-branches"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="full-name-executable test"

COMMON_DEPEND="
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-3.0.18[${PYTHON_USEDEP}]
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
	fi
}
