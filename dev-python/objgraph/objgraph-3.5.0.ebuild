# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )

inherit distutils-r1

DESCRIPTION="Draws Python object reference graphs with graphviz"
HOMEPAGE="https://mg.pov.lt/objgraph/"
SRC_URI="mirror://pypi/o/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64 arm arm64 ~ia64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="doc"

RDEPEND="media-gfx/graphviz"
BDEPEND="test? ( media-gfx/xdot )"

PATCHES=(
	"${FILESDIR}/objgraph-3.4.1-tests.patch"
)

distutils_enable_tests unittest

python_install_all() {
	use doc && local HTML_DOCS=( docs/* )
	distutils-r1_python_install_all
}
