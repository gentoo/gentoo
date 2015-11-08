# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# this ebuild is only for the libgmp.so.3 ABI SONAME

EAPI="5"

inherit eutils libtool toolchain-funcs multilib-minimal

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
	epatch "${FILESDIR}"/${PN}-4.2.1-s390.diff

	# note: we cannot run autotools here as gcc depends on this package
	elibtoolize

	# GMP uses the "ABI" env var during configure as does Gentoo (econf).
	# So, to avoid patching the source constantly, wrap things up.
	mv configure configure.wrapped || die
	cat <<-\EOF > configure
	#!/bin/sh
	exec env ABI="${GMPABI}" "$0.wrapped" "$@"
	EOF
	chmod a+rx configure
}

multilib_src_configure() {
	# Because of our 32-bit userland, 1.0 is the only HPPA ABI that works
	# http://gmplib.org/manual/ABI-and-ISA.html#ABI-and-ISA (bug #344613)
	if [[ ${CHOST} == hppa2.0-* ]] ; then
		GMPABI="1.0"
	fi

	# ABI mappings (needs all architectures supported)
	case ${ABI} in
		32|x86)       GMPABI=32;;
		64|amd64|n64) GMPABI=64;;
		[onx]32)      GMPABI=${ABI};;
	esac
	export GMPABI

	tc-export CC
	ECONF_SOURCE="${S}" econf \
		--localstatedir=/var/state/gmp \
		--disable-mpfr \
		--disable-mpbsd \
		--disable-static \
		--disable-cxx
}

multilib_src_install() {
	emake DESTDIR="${D}" install-libLTLIBRARIES
	rm "${D}"/usr/*/libgmp.{la,so} || die
}
