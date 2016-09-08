# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="(T)he k(I)cki(N) (T)ickin d(I)kumud clie(N)t"
HOMEPAGE="http://tintin.sourceforge.net/"
SRC_URI="mirror://sourceforge/tintin/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-libs/libpcre
	net-libs/gnutls
	sys-libs/readline:0
	sys-libs/zlib"
RDEPEND=${DEPEND}

S=${WORKDIR}/tt/src

src_install () {
	dobin tt++
	dodoc ../{CREDITS,FAQ,README,SCRIPTS,TODO,docs/*}
}

pkg_postinst() {
	echo
	ewarn "**** OLD TINTIN SCRIPTS ARE NOT 100% COMPATIBLE WITH THIS VERSION ****"
	ewarn "read the README for more details."
	echo
}
