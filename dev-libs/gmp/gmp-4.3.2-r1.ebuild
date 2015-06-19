# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/gmp/gmp-4.3.2-r1.ebuild,v 1.2 2014/06/06 19:27:06 vapier Exp $

# this ebuild is only for the libgmp.so.3 ABI SONAME

EAPI="3"

inherit eutils libtool toolchain-funcs

DESCRIPTION="Library for arithmetic on arbitrary precision integers, rational numbers, and floating-point numbers"
HOMEPAGE="http://gmplib.org/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND="sys-devel/m4"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.1.4-noexecstack.patch
	epatch "${FILESDIR}"/${PN}-4.3.2-ABI-multilib.patch
	epatch "${FILESDIR}"/${PN}-4.2.1-s390.diff

	sed -i -e 's:ABI = @ABI@:GMPABI = @GMPABI@:' \
		Makefile.in */Makefile.in */*/Makefile.in

	# note: we cannot run autotools here as gcc depends on this package
	elibtoolize
}

src_configure() {
	# Because of our 32-bit userland, 1.0 is the only HPPA ABI that works
	# http://gmplib.org/manual/ABI-and-ISA.html#ABI-and-ISA (bug #344613)
	if [[ ${CHOST} == hppa2.0-* ]] ; then
		export GMPABI="1.0"
	fi

	# ABI mappings (needs all architectures supported)
	case ${ABI} in
		32|x86)       export GMPABI=32;;
		64|amd64|n64) export GMPABI=64;;
		o32|n32)      export GMPABI=${ABI};;
	esac

	tc-export CC
	econf \
		--localstatedir=/var/state/gmp \
		--disable-mpfr \
		--disable-mpbsd \
		--disable-static \
		--disable-cxx
}

src_install() {
	emake install-libLTLIBRARIES DESTDIR="${D}" || die
	rm "${D}"/usr/*/libgmp.{la,so} || die
}
