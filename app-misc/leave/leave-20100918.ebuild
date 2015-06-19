# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/leave/leave-20100918.ebuild,v 1.4 2011/01/11 15:25:37 phajdan.jr Exp $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="Command-line tool from FreeBSD that reminds you when its time to leave"
HOMEPAGE="http://www.freebsd.org/cgi/cvsweb.cgi/src/usr.bin/leave/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-fix-makefile.diff"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"\
		|| die "emake failed"
}

src_install() {
	dobin leave || die "dobin failed"
	doman leave.1 || die "doman failed"
	dodoc "${FILESDIR}/README" || die "dodoc failed"
}
