# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bcrypt/bcrypt-1.1.ebuild,v 1.14 2011/03/29 19:51:17 c1pher Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A file encryption utility using Paul Kocher's implementation of the blowfish algorithm"
HOMEPAGE="http://bcrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/bcrypt/${P}.tar.gz"
SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 ppc sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin bcrypt || die
	dodoc README || die
	doman bcrypt.1 || die
}
