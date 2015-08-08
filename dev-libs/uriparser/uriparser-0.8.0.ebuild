# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Uriparser is a strictly RFC 3986 compliant URI parsing library in C"
HOMEPAGE="http://uriparser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc qt4 test unicode"

RDEPEND=""
DEPEND="virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.5.8
		qt4? ( dev-qt/qthelp:4 ) )
	test? ( >=dev-util/cpptest-1.1.1 )"

REQUIRED_USE="test? ( unicode )"

src_configure() {
	econf \
		--disable-sizedown \
		$(use_enable test) \
		--enable-char \
		$(use_enable unicode wchar_t) \
		$(use_enable doc) \
		--disable-dependency-tracking \
		--docdir=/usr/share/doc/${PF}/
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog THANKS doc/*.txt || die

	if use doc && use qt4; then
		insinto /usr/share/doc/${PF}/
		doins doc/*.qch || die  # Using doins to avoid dodoc's compression
	fi
}
