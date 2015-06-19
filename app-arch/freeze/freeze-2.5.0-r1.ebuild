# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/freeze/freeze-2.5.0-r1.ebuild,v 1.9 2013/01/13 11:31:59 ago Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Freeze/unfreeze compression program"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/utils/compress/"
SRC_URI="ftp://ftp.ibiblio.org/pub/Linux/utils/compress/${P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	!<=media-libs/mlt-0.4.2
	!media-libs/mlt[melt]
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		OPTIONS="-DDEFFILE=\\\"/etc/freeze.cnf\\\""
}

src_install() {
	dodir /usr/bin /usr/share/man/man1

	emake \
		DEST="${D}/usr/bin" \
		MANDEST="${D}/usr/share/man/man1" \
		install

	# these symlinks collide with app-forensics/sleuthkit (bug #444872)
	rm "${D}"/usr/bin/fcat "${D}"/usr/share/man/man1/fcat.1 || die

	dobin showhuf
	dodoc README *.lsm
}
