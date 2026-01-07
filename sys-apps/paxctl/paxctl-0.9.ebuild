# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Manages various PaX related program header flags for Elf32, Elf64, binaries"
HOMEPAGE="https://pax.grsecurity.net"
SRC_URI="https://pax.grsecurity.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"

BDEPEND=">=sys-devel/binutils-2.14.90.0.8-r1"

src_prepare() {
	default

	sed \
		"s:--owner 0 --group 0::g" \
		-i Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc README ChangeLog
}
