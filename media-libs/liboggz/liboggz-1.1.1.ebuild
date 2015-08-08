# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit autotools eutils

DESCRIPTION="Oggz provides a simple programming interface for reading and writing Ogg files and streams"
HOMEPAGE="http://www.xiph.org/oggz/"
SRC_URI="http://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="doc static-libs test"

RDEPEND=">=media-libs/libogg-1.2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? ( app-text/docbook-sgml-utils )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.patch

	if ! use doc; then
		sed -i -e '/AC_CHECK_PROG/s:doxygen:dIsAbLe&:' configure.ac || die
	fi

	AT_M4DIR="m4" eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" install || die
	dodoc AUTHORS ChangeLog README TODO

	find "${D}" -name '*.la' -delete
}
