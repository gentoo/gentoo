# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Collection of command line video editing utilities"
HOMEPAGE="https://tools.suckless.org/blind/"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}"/${PN}-1.1-ldflags.patch )

src_prepare() {
	default

	sed -i \
		-e '/^CC/d' \
		-e 's|/usr/local|/usr|g' \
		-e 's|^CFLAGS.*|CFLAGS += -std=c99 -pedantic -Wall -Wextra $(INCS) $(CPPFLAGS)|g' \
		-e '/^LDFLAGS.*/ { s:-s::g; s:=:+=:g; }' \
		-e 's|{|(|g;s|}|)|g' \
		config.mk || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}
