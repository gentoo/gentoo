# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1 pypi

DESCRIPTION="Stateful programmatic web browsing in Python"
HOMEPAGE="
	https://github.com/python-mechanize/mechanize/
	https://pypi.org/project/mechanize/
"

LICENSE="|| ( BSD ZPL )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ppc ~sparc x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/html5lib-0.999999999[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

PATCHES=(
	# https://github.com/python-mechanize/mechanize/pull/102
	"${FILESDIR}"/${P}-py314-tests.patch
)

python_test() {
	"${EPYTHON}" run_tests.py -v || die
}
