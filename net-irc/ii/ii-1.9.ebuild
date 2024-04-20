# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A minimalist FIFO and filesystem-based IRC client"
HOMEPAGE="https://tools.suckless.org/ii/"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ppc ~ppc64 ~riscv x86 ~amd64-linux"

src_prepare() {
	default

	sed -i -e '/^LDFLAGS/{s:-s::g; s:= :+= :g}' \
		-e '/^CFLAGS/{s: -Os::g; s:= :+= :g}' \
		-e 's|doc|doc/${PF}|' config.mk || die

	sed -i -e 's|(DOCPREFIX)/ii|(DOCPREFIX)|' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		install
}
