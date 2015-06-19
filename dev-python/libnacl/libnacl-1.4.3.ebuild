# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/libnacl/libnacl-1.4.3.ebuild,v 1.1 2015/06/15 15:08:35 mrueg Exp $

EAPI=5
PYTHON_COMPAT=(python{2_7,3_3,3_4})
inherit distutils-r1

DESCRIPTION="Python ctypes wrapper for libsodium"
HOMEPAGE="https://libnacl.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-libs/libsodium"

python_test() {
	${EPYTHON} tests/runtests.py || die
}
