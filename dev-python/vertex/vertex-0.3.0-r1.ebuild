# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="An implementation of the Q2Q protocol"
HOMEPAGE="https://github.com/twisted/vertex https://pypi.org/project/Vertex/"
SRC_URI="mirror://pypi/${TWISTED_PN:0:1}/${TWISTED_PN}/${TWISTED_P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/openssl:0
	>=dev-python/epsilon-0.6.0-r1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-0.13-r1[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all

	dodoc NAME.txt
}
