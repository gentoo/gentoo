# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-lzo/python-lzo-1.08-r1.ebuild,v 1.1 2015/01/05 07:36:48 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python interface to lzo"
HOMEPAGE="http://www.oberhumer.com/opensource/lzo/"
SRC_URI="http://www.oberhumer.com/opensource/lzo/download/LZO-v1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/lzo:2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/lzo2compat.patch" )

python_test() {
	"${PYTHON}" tests/test.py || die "tests failed"
}
