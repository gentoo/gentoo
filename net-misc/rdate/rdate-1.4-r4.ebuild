# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/rdate/rdate-1.4-r4.ebuild,v 1.10 2013/04/13 07:17:55 ago Exp $

EAPI="5"

inherit flag-o-matic

DESCRIPTION="use TCP or UDP to retrieve the current time of another machine"
HOMEPAGE="http://www.apps.ietf.org/rfc/rfc868.html"
SRC_URI="ftp://people.redhat.com/sopwith/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="ipv6"

DEPEND=""

src_prepare() {
	sed -i \
		-e '/^CFLAGS=/d' \
		-e '/^rdate: /,+1d' \
		-e '/\tinstall/s:\([^ ]\+\)$:$(DESTDIR)&:' \
		Makefile || die "Sed failed!"
}

src_compile() {
	use ipv6 && append-cppflags "-DINET6"
	tc-export CC
	emake
}

src_install(){
	emake DESTDIR="${D}" install
	newinitd "${FILESDIR}"/rdate-initd-1.4-r3 rdate
	newconfd "${FILESDIR}"/rdate-confd rdate
}
