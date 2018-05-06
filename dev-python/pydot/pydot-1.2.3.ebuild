# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Python interface to Graphviz's Dot language"
HOMEPAGE="https://github.com/erocarrera/pydot https://pypi.org/project/pydot"
# pypi releases don't include tests
SRC_URI="https://github.com/erocarrera/pydot/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	media-gfx/graphviz"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/chardet[${PYTHON_USEDEP}] )"

python_test() {
	cd test || die
	"${PYTHON}" pydot_unittest.py || die "Test failed with ${EPYTHON}"
}
