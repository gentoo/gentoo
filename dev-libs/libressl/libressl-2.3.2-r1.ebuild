# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib-minimal

DESCRIPTION="Free version of the SSL/TLS protocol forked from OpenSSL"
HOMEPAGE="http://www.libressl.org/"
SRC_URI="http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${P}.tar.gz"

LICENSE="ISC openssl"
SLOT="0/37" # reflects ABI of libcrypto.so and libssl.so
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~x86"
IUSE="+asm static-libs"

RDEPEND="!dev-libs/openssl:0"
DEPEND="${RDEPEND}"
PDEPEND="app-misc/ca-certificates"

src_prepare() {
	touch crypto/Makefile.in

	sed -i \
		-e '/^[ \t]*CFLAGS=/s#-g ##' \
		-e '/^[ \t]*CFLAGS=/s#-g"#"#' \
		-e '/^[ \t]*CFLAGS=/s#-O2 ##' \
		-e '/^[ \t]*CFLAGS=/s#-O2"#"#' \
		-e '/^[ \t]*USER_CFLAGS=/s#-O2 ##' \
		-e '/^[ \t]*USER_CFLAGS=/s#-O2"#"#' \
		configure || die "fixing CFLAGS failed"
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable asm) \
		$(use_enable static-libs static)
}

multilib_src_test() {
	emake check
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
