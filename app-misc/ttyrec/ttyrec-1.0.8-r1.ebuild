# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ttyrec/ttyrec-1.0.8-r1.ebuild,v 1.2 2013/09/01 13:15:38 grobian Exp $

EAPI=5

inherit base flag-o-matic toolchain-funcs

DESCRIPTION="tty recorder"
HOMEPAGE="http://namazu.org/~satoru/ttyrec/"
SRC_URI="http://namazu.org/~satoru/ttyrec/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

# Bug 331843
PATCHES=( "${FILESDIR}/${P}-ldflags.patch" )

src_compile() {
	# Bug 106530
	[[ ${CHOST} != *-darwin* ]] && append-cppflags -DSVR4 -D_XOPEN_SOURCE=500
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ttyrec ttyplay ttytime
	dodoc README
	doman *.1
}
