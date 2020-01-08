# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Draws Python object reference graphs with graphviz"
HOMEPAGE="https://mg.pov.lt/objgraph/"
SRC_URI="mirror://pypi/o/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="doc"

RDEPEND="media-gfx/graphviz"
DEPEND="dev-python/setuptools"

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=(  docs/* )
	distutils-r1_python_install_all
}
