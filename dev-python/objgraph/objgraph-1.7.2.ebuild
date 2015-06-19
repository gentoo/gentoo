# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/objgraph/objgraph-1.7.2.ebuild,v 1.1 2013/11/03 08:31:21 heroxbd Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Draws Python object reference graphs with graphviz"
HOMEPAGE="http://mg.pov.lt/objgraph/"
SRC_URI="mirror://pypi/o/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE="doc"

DEPEND=""
RDEPEND="media-gfx/graphviz"

python_install_all() {
	use doc && local HTML_DOCS=(  docs/* )

	distutils-r1_python_install_all
}
