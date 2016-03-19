# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="farbfeld simple image format tools"
HOMEPAGE="http://tools.suckless.org/farbfeld/"
SRC_URI="http://dl.suckless.org/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/libjpeg-turbo
	media-libs/libpng:*
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	sed config.mk \
		-e '/^CC/d' \
		-e 's|/usr/local|/usr|g' \
		-e 's|^CFLAGS.*|CFLAGS += -std=c99 -pedantic -Wall -Wextra $(INCS) $(CPPFLAGS)|g' \
		-e 's|^LDFLAGS.*|LDFLAGS += $(LIBS)|g' \
		-e 's|{|(|g;s|}|)|g' \
		-i || die

	sed Makefile \
		-e 's|{|(|g;s|}|)|g' \
		-e 's|^	@|	|g' \
		-i || die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${D}" install MANPREFIX=/usr/share/man
}
