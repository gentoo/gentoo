# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ftplib/ftplib-3.1.1.ebuild,v 1.1 2011/12/22 18:10:49 ssuominen Exp $

EAPI=4
inherit eutils multilib toolchain-funcs versionator

DEB_REV=9
MY_PV=$(replace_version_separator 2 -)

DESCRIPTION="A set of routines that implement the FTP protocol"
HOMEPAGE="http://nbpfaus.net/~pfau/ftplib/"
DEB_URI="mirror://debian/pool/main/f/${PN}"
SRC_URI="${DEB_URI}/${PN}_${MY_PV}.orig.tar.gz
	${DEB_URI}/${PN}_${MY_PV}-${DEB_REV}.debian.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/{check-getservbyname-failure,fix-ascii-read-without-eol}

	sed -i \
		-e '/shared/s:$(CC):$(CC) $(LDFLAGS):' \
		-e 's:/usr/local:$(DESTDIR)/usr:' \
		-e '/^LDFLAGS/s:=:+=:' \
		-e "s:/lib:/$(get_libdir):" \
		linux/Makefile || die
}

src_compile() {
	tc-export CC
	emake -C linux DEBUG="${CFLAGS}"
}

src_install() {
	dodir /usr/bin /usr/include /usr/$(get_libdir)
	emake -C linux DESTDIR="${D}" install
	dodoc additional_rfcs CHANGES ftplib.lsm NOTES README* RFC959.txt TODO
}
