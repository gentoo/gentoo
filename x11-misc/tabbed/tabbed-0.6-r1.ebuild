# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit savedconfig toolchain-funcs

DESCRIPTION="Simple generic tabbed fronted to xembed aware applications"
HOMEPAGE="https://tools.suckless.org/tabbed"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="
	x11-base/xorg-proto
	${RDEPEND}
"

src_prepare() {
	default
	sed config.mk \
		-e '/^CC/d' \
		-e 's|/usr/local|/usr|g' \
		-e 's|^CFLAGS.*|CFLAGS += -std=c99 -pedantic -Wall $(INCS) $(CPPFLAGS)|g' \
		-e 's|^LDFLAGS.*|LDFLAGS += $(CFLAGS) $(LIBS)|g' \
		-e 's|^LIBS.*|LIBS = -lX11|g' \
		-e 's|{|(|g;s|}|)|g' \
		-i || die

	sed Makefile \
		-e 's|{|(|g;s|}|)|g' \
		-e '/^[[:space:]]*@echo/d' \
		-e 's|^	@|	|g' \
		-i || die

	restore_config config.h
}

src_compile() {
	emake CC=$(tc-getCC)
}
src_install() {
	default
	save_config config.h
}
