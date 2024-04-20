# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A tool to query or alter a process' scheduling policy"
HOMEPAGE="https://github.com/freequaos/schedtool"
SRC_URI="https://github.com/freequaos/schedtool/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ~mips ppc ~riscv x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-c99.patch
)

src_prepare() {
	default
	sed \
		-e '/^CFLAGS=/d;/^install:/s@ install-doc zipman@@' \
		-e '/install/s@\(schedtool.8\).gz@\1@' \
		-i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTPREFIX="${ED}"/usr install
	dodoc CHANGES INSTALL PACKAGERS README SCHED_DESIGN TODO TUNING
}
