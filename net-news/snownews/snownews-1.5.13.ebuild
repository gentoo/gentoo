# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools toolchain-funcs

DESCRIPTION="Command-line RSS feed reader"
HOMEPAGE="https://github.com/kouya/snownews"
SRC_URI="https://github.com/kouya/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="unicode"

COMMON_DEPEND="
	>=dev-libs/libxml2-2.5.6
	>=sys-libs/ncurses-5.3:0=[unicode?]
	dev-libs/openssl:0=
"
RDEPEND="
	${COMMON_DEPEND}
	dev-perl/XML-LibXML
	dev-perl/libwww-perl
"

DEPEND="
	${COMMON_DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	tc-export PKG_CONFIG
	sed -i 's|-lncurses|`\\$(PKG_CONFIG) --libs '"$(usex unicode ncursesw ncurses)"'`|' configure || die
	sed -i 's|$(INSTALL) -s snownews|$(INSTALL) snownews|' Makefile || die
}

src_configure() {
	# perl script, not autotools based
	./configure --prefix="${EPREFIX}/usr" || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}"
}
