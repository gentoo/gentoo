# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsoundtouch/libsoundtouch-1.7.1.ebuild,v 1.10 2015/01/29 17:45:38 mgorny Exp $

EAPI=5
inherit autotools eutils flag-o-matic

MY_PN=${PN/lib}

DESCRIPTION="Audio processing library for changing tempo, pitch and playback rates"
HOMEPAGE="http://www.surina.net/soundtouch/"
SRC_URI="http://www.surina.net/soundtouch/${P/lib}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="cpu_flags_x86_sse2 static-libs"

DEPEND="virtual/pkgconfig"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.7.0-flags.patch
	sed -i "s:^\(pkgdoc_DATA=\)COPYING.TXT :\1:" Makefile.am || die
	sed -i 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:g' configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-shared \
		--disable-integer-samples \
		--enable-x86-optimizations=$(usex cpu_flags_x86_sse2 sse2) \
		$(use_enable static-libs static)
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="${EPREFIX}"/usr/share/doc/${PF}/html install
	prune_libtool_files
}
