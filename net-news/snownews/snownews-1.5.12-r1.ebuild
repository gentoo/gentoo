# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Snownews, a text-mode RSS/RDF newsreader"
HOMEPAGE="http://snownews.kcore.de/"
SRC_URI="http://home.kcore.de/~kiza/software/snownews/download/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="unicode"

COMMON_DEPEND="
	>=dev-libs/libxml2-2.5.6
	>=sys-libs/ncurses-5.3[unicode?]
	dev-libs/openssl
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
	sed -i -e "s|-O2||g" configure || die
	sed -i -e 's|$(INSTALL) -s|$(INSTALL)|g' Makefile || die
}

src_configure() {
	tc-export PKG_CONFIG
	if use unicode; then
		sed -i -e 's|-lncurses|`\\$(PKG_CONFIG) --libs ncursesw`|' configure || die
	else
		sed -i -e 's|-lncurses|`\\$(PKG_CONFIG) --libs ncurses`|' configure || die
	fi

	# perl script, not autotools based
	./configure --prefix="${EPREFIX}/usr" || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake PREFIX="${ED}/usr" install

	dodoc AUTHOR Changelog CREDITS README README.de README.patching
}
