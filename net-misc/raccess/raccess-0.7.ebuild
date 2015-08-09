# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs multilib

DESCRIPTION="Remote Access Session is an systems security analyzer"
HOMEPAGE="http://salix.org/raccess/"
SRC_URI="http://salix.org/raccess/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ~ppc ~amd64"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-r1-asneeded.patch
	epatch "${FILESDIR}"/${P}-glibc210.patch
	sed -i '/^BINFILES/s:@bindir@:/usr/$(get_libdir)/raccess:' src/Makefile.in
	sed -i '/^bindir/s:@bindir@/exploits:/usr/$(get_libdir)/raccess:' exploits/Makefile.in
}

src_compile() {
	econf --sysconfdir=/etc/raccess
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS PROJECT_PLANNING README
}
