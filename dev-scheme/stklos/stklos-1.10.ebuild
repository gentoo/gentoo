# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/stklos/stklos-1.10.ebuild,v 1.2 2012/06/21 06:29:22 hkbst Exp $

EAPI="3"

DESCRIPTION="fast and light Scheme implementation"
HOMEPAGE="http://www.stklos.net"
SRC_URI="http://www.stklos.net/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads"
DEPEND="dev-libs/gmp dev-libs/libpcre virtual/libffi dev-libs/boehm-gc[threads?]"
RDEPEND="${DEPEND}"

#parallel build failure reported upstream
MAKEOPTS=-j1

src_prepare() {
	# kill bundled libs
	rm -rf "${S}"/{ffi,gc,gmp,pcre}
}

src_configure() {
	econf --enable-threads=$(if use threads; then echo pthreads; else echo none; fi) \
		--without-gmp-light --without-provided-gc \
		--without-provided-regexp --without-provided-ffi
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS PACKAGES-USED PORTING-NOTES README SUPPORTED-SRFIS \
		|| die "dodocs failed"
}
