# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Exif Jpeg camera setting parser and thumbnail remover"
HOMEPAGE="http://www.sentex.net/~mwandel/jhead"
SRC_URI="http://www.sentex.net/~mwandel/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

src_prepare(){
	# bug 275200 - respect flags and use mktemp instead of mkstemp
	eapply "${FILESDIR}/${PN}-2.90-mkstemp_respect_flags.patch"
	cp "${FILESDIR}/Makefile" makefile || die
	eapply_user
}

src_install() {
	dobin ${PN}
	dodoc *.txt
	docinto html
	dodoc *.html
	doman ${PN}.1
	doheader ${PN}.h
	dolib.so lib${PN}.so*
}
