# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nettle/nettle-2.7.1.ebuild,v 1.13 2014/06/10 00:41:07 vapier Exp $

EAPI=5

inherit eutils autotools multilib

DESCRIPTION="Low-level cryptographic library"
HOMEPAGE="http://www.lysator.liu.se/~nisse/nettle/"
SRC_URI="http://www.lysator.liu.se/~nisse/archive/${P}.tar.gz"

LICENSE="|| ( LGPL-3 LGPL-2.1 )"
SLOT="0/4" # subslot = libnettle soname version
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc +gmp neon static-libs test"

DEPEND="gmp? ( dev-libs/gmp )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.7-shared.patch

	sed -e '/CFLAGS=/s: -ggdb3::' \
		-e 's/solaris\*)/sunldsolaris*)/' \
		-i configure.ac || die

	# conditionally build tests and examples required by tests
	use test || sed -i '/SUBDIRS/s/testsuite examples//' Makefile.in || die

	eautoreconf
}

src_configure() {
	# --disable-openssl bug #427526
	econf \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		$(use_enable gmp public-key) \
		$(use_enable static-libs static) \
		--disable-openssl \
		$(use_enable doc documentation) \
		$(use_enable neon arm-neon)
}

src_install() {
	default

	if use doc ; then
		dohtml nettle.html
		dodoc nettle.pdf
	fi
}
