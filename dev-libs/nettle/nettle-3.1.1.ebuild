# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
AUTOTOOLS_AUTORECONF=yes

inherit eutils autotools-multilib multilib toolchain-funcs

DESCRIPTION="Low-level cryptographic library"
HOMEPAGE="http://www.lysator.liu.se/~nisse/nettle/"
SRC_URI="http://www.lysator.liu.se/~nisse/archive/${P}.tar.gz"

LICENSE="|| ( LGPL-3 LGPL-2.1 )"
SLOT="0/6" # subslot = libnettle soname version
KEYWORDS="alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x86-solaris"
IUSE="doc +gmp neon static-libs test cpu_flags_x86_aes"

DEPEND="gmp? ( dev-libs/gmp:0[${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r17
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/nettle/nettle-stdint.h
	/usr/include/nettle/version.h
)

src_prepare() {
	sed -e '/CFLAGS=/s: -ggdb3::' \
		-e 's/solaris\*)/sunldsolaris*)/' \
		-i configure.ac || die

	# conditionally build tests and examples required by tests
	use test || sed -i '/SUBDIRS/s/testsuite examples//' Makefile.in || die

	autotools-utils_src_prepare
}

multilib_src_configure() {
	# --disable-openssl bug #427526
	ECONF_SOURCE="${S}" econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-openssl \
		--disable-fat \
		$(use_enable gmp public-key) \
		$(use_enable static-libs static) \
		$(tc-is-static-only && echo --disable-shared) \
		$(use_enable doc documentation) \
		$(use_enable neon arm-neon) \
		$(use_enable cpu_flags_x86_aes x86-aesni)
}

multilib_src_install_all() {
	einstalldocs
	if use doc ; then
		dohtml nettle.html
		dodoc nettle.pdf
	fi
}
