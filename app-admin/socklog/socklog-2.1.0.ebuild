# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/socklog/socklog-2.1.0.ebuild,v 1.2 2011/08/28 22:43:50 vapier Exp $

EAPI="3"

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="small secure replacement for syslogd with automatic log rotation"
HOMEPAGE="http://smarden.org/socklog/"
SRC_URI="http://smarden.org/socklog/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="static"

RDEPEND=">=sys-process/runit-1.4.0"

S=${WORKDIR}/admin/${P}/src

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1.0-headers.patch
	use static && append-ldflags -static
	echo "$(tc-getCC) ${CFLAGS} ${CPPFLAGS}" > conf-cc
	echo "$(tc-getCC) ${CFLAGS} ${LDFLAGS}" > conf-ld
}

src_install() {
	dobin tryto uncat socklog-check || die
	dosbin socklog socklog-conf || die

	cd ..
	dodoc package/CHANGES
	dohtml doc/*.html
	doman man/*
}
