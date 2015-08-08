# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Widgets for graphing data in real-time using PyGTK, and UI components for controlling the graphs"
HOMEPAGE="http://navi.cx/svn/misc/trunk/rtgraph/web/index.html"
SRC_URI="http://navi.picogui.org/releases/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
IUSE="examples"

DEPEND="dev-python/pygtk:2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	if use examples; then
		mkdir examples || die
		mv ./{cpu_meter.py,graph_ui.py,isometric_graph.py,line_graph.py,polar_graph.py,tweak_graph.py} examples || die
	fi
	distutils-r1_python_prepare_all
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
