# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Stateful programmatic web browsing in Python"
HOMEPAGE="https://github.com/python-mechanize/mechanize"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="|| ( BSD ZPL )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/html5lib-0.999999999[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.8-python3.11-test-order.patch
)

python_test() {
	"${EPYTHON}" run_tests.py || die
}
