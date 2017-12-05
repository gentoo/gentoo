# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit fixheadtails toolchain-funcs

DESCRIPTION="A minimalist FIFO and filesystem-based IRC client"
HOMEPAGE="https://tools.suckless.org/ii/"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

src_prepare() {
	default

	sed -i \
		-e '/^CFLAGS/{s: -Os::g; s:= :+= :g}' \
		-e '/^CC/d' \
		-e '/^LDFLAGS/{s:-s::g; s:= :+= :g}' \
		config.mk || die
	sed -i \
		-e 's|@${CC}|$(CC)|g' \
		Makefile || die

	ht_fix_file query.sh
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ii
	newbin query.sh ii-query
	dodoc CHANGES FAQ README
	doman *.1
}
