# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Async-capable DNS stub resolver library"
HOMEPAGE="https://www.corpit.ru/mjt/udns.html"
SRC_URI="https://www.corpit.ru/mjt/udns/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ppc ppc64 sparc x86"
IUSE="ipv6 +tools"

RDEPEND="tools? ( !mail-filter/rblcheck )"

src_configure() {
	# Uses non-standard configure script, econf doesn't work
	CC="$(tc-getCC)" RANLIB="$(tc-getRANLIB)" edo ./configure $(use_enable ipv6)
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
