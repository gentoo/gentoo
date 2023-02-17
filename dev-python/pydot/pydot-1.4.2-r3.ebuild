# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Python interface to Graphviz's Dot language"
HOMEPAGE="https://github.com/pydot/pydot https://pypi.org/project/pydot/"
# pypi releases don't include tests
SRC_URI="https://github.com/pydot/pydot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	media-gfx/graphviz"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/chardet[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.2-pyparsing-3.patch
)

python_test() {
	cd test || die
	"${PYTHON}" pydot_unittest.py || die "Test failed with ${EPYTHON}"
}
