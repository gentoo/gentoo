# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit distutils-r1

MY_P="${P/editobj/EditObj}"

DESCRIPTION="EditObj can create a dialog box to edit ANY Python object"
SRC_URI="http://download.gna.org/songwrite/${MY_P}.tar.gz"
HOMEPAGE="http://home.gna.org/oomadness/en/editobj/index.html"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
SLOT="0"
IUSE="+examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

python_install_all() {
	use examples && local EXAMPLES=( demo/. )
	distutils-r1_python_install_all
}
