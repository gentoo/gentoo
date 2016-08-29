# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Fast XML-RPC implementation for Python"
HOMEPAGE="https://sourceforge.net/projects/py-xmlrpc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${PN/py-/}

python_install_all() {
	use examples && local EXAMPLES=( doc/examples.py )

	distutils-r1_python_install_all
}
