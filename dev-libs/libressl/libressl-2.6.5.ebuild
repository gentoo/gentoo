# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="Free version of the SSL/TLS protocol forked from OpenSSL"
HOMEPAGE="https://www.libressl.org/"
SRC_URI="https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/${P}.tar.gz"

LICENSE="ISC openssl"
# Reflects ABI of libcrypto.so and libssl.so.  Since these can differ,
# we'll try to use the max of either.  However, if either change between
# versions, we have to change the subslot to trigger rebuild of consumers.
SLOT="0/44"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="+asm static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( static-libs )"

RDEPEND="!dev-libs/openssl:0"
DEPEND="${RDEPEND}"
PDEPEND="app-misc/ca-certificates"

PATCHES=( "${FILESDIR}/libressl-2.6.4-hppa-asm.patch" )

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

	default
	eautoreconf
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
	find "${D}" -name '*.la' -exec rm -f {} + || die
}
