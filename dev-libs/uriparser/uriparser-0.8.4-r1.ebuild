# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Uriparser is a strictly RFC 3986 compliant URI parsing library in C"
HOMEPAGE="http://uriparser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc qt5 test unicode"

RDEPEND=""
DEPEND="virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.5.8
		qt5? ( dev-qt/qthelp:5 ) )
	test? ( >=dev-util/cpptest-1.1.1 )"

REQUIRED_USE="test? ( unicode )"

PATCHES=( "${FILESDIR}"/${P}-doc-install.patch )

DOCS=( AUTHORS ChangeLog THANKS )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-sizedown \
		$(use_enable test) \
		--enable-char \
		$(use_enable unicode wchar_t) \
		$(use_enable doc) \
		--docdir=/usr/share/doc/${PF}/
}

src_install() {
	default

	if use doc && use qt5; then
		dodoc doc/*.qch
		docompress -x /usr/share/doc/${PF}/${P}.qch
	fi
}
