# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs

DESCRIPTION="farbfeld simple image format tools"
HOMEPAGE="https://tools.suckless.org/farbfeld/"
EGIT_REPO_URI="https://git.suckless.org/farbfeld"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""

RDEPEND="
	media-libs/libjpeg-turbo
	media-libs/libpng:*
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default

	sed -i \
		-e '/^CC/d' \
		-e 's|/usr/local|/usr|g' \
		-e 's|^CFLAGS.*|CFLAGS += -std=c99 -pedantic -Wall -Wextra $(INCS) $(CPPFLAGS)|g' \
		-e 's|^LDFLAGS.*|LDFLAGS += $(LIBS)|g' \
		config.mk || die
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${D}" install MANPREFIX=/usr/share/man
}
