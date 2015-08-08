# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic toolchain-funcs

DESCRIPTION="use TCP or UDP to retrieve the current time of another machine"
HOMEPAGE="http://www.apps.ietf.org/rfc/rfc868.html"
SRC_URI="ftp://people.redhat.com/sopwith/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="ipv6"

DEPEND=""

src_compile() {
	use ipv6 && append-cppflags "-DINET6"
	emake RCFLAGS="${CFLAGS} ${CPPFLAGS} ${LDFLAGS}" CC="$(tc-getCC)" || die
}

src_install(){
	emake -j1 prefix="${D}/usr" install || die "make install failed"
	newinitd "${FILESDIR}"/rdate-initd-1.4-r3 rdate
	newconfd "${FILESDIR}"/rdate-confd rdate
}
