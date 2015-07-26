# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/udns/udns-0.4.ebuild,v 1.2 2015/07/23 20:32:55 pacho Exp $

EAPI="4"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Async-capable DNS stub resolver library"
HOMEPAGE="http://www.corpit.ru/mjt/udns.html"
SRC_URI="http://www.corpit.ru/mjt/udns/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="ipv6 static +tools"

# Yes, this doesn't depend on any other library beside "system" set
DEPEND=""
RDEPEND=""

src_configure() {
	# Uses non-standard configure script, econf doesn't work
	CC=$(tc-getCC) ./configure $(use_enable ipv6) || die "Configure failed"
}

src_compile() {
	if use tools; then
		emake shared
	else
		emake sharedlib
	fi
}

src_install() {
	dolib.so libudns.so.0
	dosym libudns.so.0 "/usr/$(get_libdir)/libudns.so"

	if use tools; then
		newbin dnsget_s dnsget
		newbin ex-rdns_s ex-rdns
		newbin rblcheck_s rblcheck
	fi

	insinto /usr/include
	doins udns.h

	doman udns.3
	if use tools; then
		doman dnsget.1 rblcheck.1
	fi
	dodoc NEWS NOTES TODO
}
