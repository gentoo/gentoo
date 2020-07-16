# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Async-capable DNS stub resolver library"
HOMEPAGE="http://www.corpit.ru/mjt/udns.html"
SRC_URI="http://www.corpit.ru/mjt/udns/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~ppc64 sparc x86"
IUSE="ipv6 static +tools"

src_configure() {
	# Uses non-standard configure script, econf doesn't work
	CC=$(tc-getCC) ./configure $(use_enable ipv6) || die "Configure failed"
}

src_compile() {
	emake $(usex tools shared sharedlib)
}

src_install() {
	dolib.so libudns.so.0
	dosym libudns.so.0 /usr/$(get_libdir)/libudns.so

	if use tools; then
		newbin dnsget_s dnsget
		newbin ex-rdns_s ex-rdns
		newbin rblcheck_s rblcheck
	fi

	doheader udns.h

	doman udns.3
	use tools && doman dnsget.1 rblcheck.1

	dodoc NEWS NOTES TODO
}
