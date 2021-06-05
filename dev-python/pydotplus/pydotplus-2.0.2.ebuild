# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Improved version of the old pydot project"
HOMEPAGE="https://pydotplus.readthedocs.org/"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	media-gfx/graphviz"

distutils_enable_tests unittest

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

python_test() {
	cd test || die
	"${EPYTHON}" pydot_unittest.py || die
}
