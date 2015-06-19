# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ftplib/ftplib-4.0.ebuild,v 1.2 2014/03/23 06:54:44 vapier Exp $

EAPI=4
inherit eutils multilib toolchain-funcs versionator

DESCRIPTION="A set of routines that implement the FTP protocol"
HOMEPAGE="http://nbpfaus.net/~pfau/ftplib/"
SRC_URI="http://nbpfaus.net/~pfau/ftplib/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -i \
		-e '/shared/s:$(CC):$(CC) $(LDFLAGS):' \
		-e 's:/usr/local:$(DESTDIR)/usr:' \
		-e '/^LDFLAGS/s:=:+=:' \
		-e "s:/lib:/$(get_libdir):" \
		-e '/ar -rcs/s:ar:$(AR):' \
		src/Makefile || die
}

src_compile() {
	tc-export AR CC
	emake -C src DEBUG="${CFLAGS} ${CPPFLAGS}"
}

src_install() {
	dodir /usr/bin /usr/include /usr/$(get_libdir)
	emake -C src DESTDIR="${ED}" install
	dodoc additional_rfcs CHANGES README* RFC959.txt
	dohtml html/*
}
