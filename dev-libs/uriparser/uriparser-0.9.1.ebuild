# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Uriparser is a strictly RFC 3986 compliant URI parsing library in C"
HOMEPAGE="https://uriparser.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="doc qt5 test unicode"

RDEPEND=""
DEPEND="virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.5.8
		qt5? ( dev-qt/qthelp:5 ) )
	test? ( >=dev-cpp/gtest-1.8.1 )"

REQUIRED_USE="test? ( unicode )"
RESTRICT="!test? ( test )"

DOCS=( AUTHORS ChangeLog THANKS )

src_configure() {
	econf \
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
