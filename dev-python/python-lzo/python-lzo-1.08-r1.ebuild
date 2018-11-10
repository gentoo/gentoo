# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils prefix

DESCRIPTION="Python interface to lzo"
HOMEPAGE="http://www.oberhumer.com/opensource/lzo/"
SRC_URI="http://www.oberhumer.com/opensource/lzo/download/LZO-v1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/lzo:2"
RDEPEND="${DEPEND}"

python_test() {
	"${PYTHON}" tests/test.py || die "tests failed"
}

src_prepare() {
	epatch "$(PREFIX_LINE_MATCH='/##/!' \
		prefixify_ro "${FILESDIR}"/lzo2compat.patch)"
}
