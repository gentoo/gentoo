# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy pypy3 )

inherit distutils-r1

MY_PN="Reverend"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Reverend - Simple Bayesian classifier"
HOMEPAGE="http://divmod.org/trac/wiki/DivmodReverend https://pypi.python.org/pypi/Reverend"
SRC_URI="mirror://sourceforge/reverend/${MY_P}.tar.gz mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"

python_install_all() {
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
