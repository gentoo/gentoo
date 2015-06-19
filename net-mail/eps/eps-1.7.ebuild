# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/eps/eps-1.7.ebuild,v 1.3 2011/06/22 21:24:53 ranger Exp $

EAPI=3

inherit toolchain-funcs multilib

DESCRIPTION="Inter7 Email Processing and mht System library"
HOMEPAGE="http://www.inter7.com/eps"
SRC_URI="http://www.inter7.com/eps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="sys-apps/sed"
RDEPEND=""

src_prepare() {
	sed -i -e 's:/usr:$(DESTDIR)$(prefix):g' \
		-e 's:\(DEFS.*\):\1 $(CFLAGS):' \
		-e 's:$(DEFS):$(DEFS) -fPIC:' \
		-e 's:-shared:-shared -Wl,-soname,libeps.so $(LDFLAGS):' \
		-e 's:cp -pf:cp -f:g' \
		Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" || die "emake failed"
}

src_install() {
	emake prefix=/usr DESTDIR="${D}" LIBDIR="${D}/usr/$(get_libdir)" install \
		|| die "emake install failed"
	dodoc ChangeLog TODO doc/*
}
