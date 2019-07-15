# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

IUSE=""

DESCRIPTION="IAX (Inter Asterisk eXchange) Library"
HOMEPAGE="https://www.digium.com/"
LICENSE="LGPL-2"
DEPEND=""
RDEPEND=""
SLOT="0"
SRC_URI="https://www.digium.com/pub/libiax/${P}.tar.gz"

D_PREFIX=/usr

KEYWORDS="ppc x86"

src_compile() {
	./configure --prefix=${D_PREFIX} --enable-autoupdate

	export UCFLAGS="${CFLAGS}"

	emake || die
}

src_install () {
	make prefix="${D}"/${D_PREFIX} install
	dodoc NEWS AUTHORS README
}
