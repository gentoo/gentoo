# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Stateful programmatic web browsing in Python"
HOMEPAGE="https://github.com/python-mechanize/mechanize"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( BSD ZPL )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/html5lib-0.999999999[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

PATCHES=(
	# https://github.com/python-mechanize/mechanize/commit/2a563ec4fbc394ec5976dda0f528db43d28a2706
	# https://github.com/python-mechanize/mechanize/commit/bc6a2ca7b17e11f2533ada67f0bf92124d4a3cac
	"${FILESDIR}/${P}-py310.patch"
)

python_test() {
	"${EPYTHON}" run_tests.py || die
}
