# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/vertex/vertex-0.3.0-r1.ebuild,v 1.4 2015/04/08 08:04:54 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="An implementation of the Q2Q protocol"
HOMEPAGE="http://divmod.org/trac/wiki/DivmodVertex http://pypi.python.org/pypi/Vertex"
SRC_URI="mirror://pypi/${TWISTED_PN:0:1}/${TWISTED_PN}/${TWISTED_P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/openssl
	>=dev-python/epsilon-0.6.0-r1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13-r1[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all

	dodoc NAME.txt
}
