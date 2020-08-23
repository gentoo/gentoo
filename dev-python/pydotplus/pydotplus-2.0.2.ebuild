# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Improved version of the old pydot project"
HOMEPAGE="https://pydotplus.readthedocs.org/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	media-gfx/graphviz
"
DEPEND="test? ( ${RDEPEND} )"

PATCHES=( "${FILESDIR}/${P}-tests.patch" )

python_test() {
	pushd test > /dev/null || die
		python pydot_unittest.py || die
	popd > /dev/null || die
}
