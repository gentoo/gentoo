# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Draws Python object reference graphs with graphviz"
HOMEPAGE="https://mg.pov.lt/objgraph/"
SRC_URI="mirror://pypi/o/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="media-gfx/graphviz"
DEPEND="dev-python/setuptools
	test? ( media-gfx/xdot )"

python_test() {
	esetup.py test || die
}

python_install_all() {
	use doc && local HTML_DOCS=(  docs/* )
	distutils-r1_python_install_all
}
