# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/frobby/frobby-0.9.0-r1.ebuild,v 1.4 2013/07/18 12:51:07 tomka Exp $

EAPI=4

inherit eutils

DESCRIPTION="Software system and project for computations with monomial ideals"
HOMEPAGE="http://www.broune.com/frobby/"
SRC_URI="http://www.broune.com/frobby/frobby_v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc static-libs"

RDEPEND="dev-libs/gmp[cxx]"
DEPEND="${RDEPEND}
	doc? ( virtual/latex-base )"

S="${WORKDIR}/frobby_v${PV}"

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-cflags-no-strip-soname.patch" \
		"${FILESDIR}/${PN}-gcc-4.7.patch" \
		"${FILESDIR}/${PN}-gmp-5.1.patch"
	# CXXFLAGS are called CPPFLAGS
	sed "s/CPPFLAGS/CXXFLAGS/" -i Makefile || die
}

src_compile() {
	# Makefile uses the value of CXX which may be defined in /etc/env,
	# breaking cross-compile.
	CXX=$(tc-getCXX) emake
	MODE=shared CXX=$(tc-getCXX) emake library
	use static-libs && CXX=$(tc-getCXX) emake library
	use doc && emake docPdf
}

src_install() {
	dobin bin/frobby
	dolib.so bin/libfrobby.so
	dosym libfrobby.so "${PREFIX}/usr/$(get_libdir)/libfrobby.so.0"
	use static-libs && dolib.a bin/libfrobby.a

	insinto /usr/include
	doins src/frobby.h

	insinto /usr/include/"${PN}"
	doins src/stdinc.h

	use doc && dodoc bin/manual.pdf
}
