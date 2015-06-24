# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/ncompress/ncompress-4.2.4.3.ebuild,v 1.7 2015/06/24 15:04:26 vapier Exp $

inherit toolchain-funcs

DESCRIPTION="Another uncompressor for compatibility"
HOMEPAGE="https://github.com/vapier/ncompress"
SRC_URI="mirror://sourceforge/ncompress/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin compress || die
	dosym compress /usr/bin/uncompress
	doman compress.1
	echo '.so compress.1' > "${D}"/usr/share/man/man1/uncompress.1
	dodoc Acknowleds Changes LZW.INFO README
}
