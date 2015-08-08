# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_AUTOMAKE="1.11" # bug 419455

inherit autotools eutils flag-o-matic libtool toolchain-funcs multilib-minimal

MY_P=${P%_*}
MY_PV=${PV%_*}
DEB_PATCH=${PV#*p}

DESCRIPTION="Convert files between various character sets"
HOMEPAGE="http://recode.progiciels-bpi.ca/"
SRC_URI="
	mirror://gnu/${PN}/${MY_P}.tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_${MY_PV}-${DEB_PATCH}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="nls static-libs"

DEPEND="
	sys-devel/flex
	nls? ( sys-devel/gettext )"
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm "${WORKDIR}"/debian/patches/series || die
	epatch \
		"${FILESDIR}/${MY_P}-gettextfix.diff" \
		"${FILESDIR}"/${MY_P}-as-if.patch \
		"${WORKDIR}"/debian/patches/*
	sed -i '1i#include <stdlib.h>' src/argmatch.c || die

	# Remove old libtool macros
	rm "${S}"/acinclude.m4 || die

	eautoreconf
	elibtoolize
}

multilib_src_configure() {
	# on solaris -lintl is needed to compile
	[[ ${CHOST} == *-solaris* ]] && append-libs "-lintl"
	# --without-included-gettext means we always use system headers
	# and library
	ECONF_SOURCE="${S}" econf \
		--without-included-gettext \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -exec rm -f {} + || die
	rm -f "${ED}"/usr/lib/charset.alias || die
}
