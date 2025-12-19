# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="PolyGlotMan man page translator AKA RosettaMan"
HOMEPAGE="https://sourceforge.net/projects/polyglotman/"
SRC_URI="https://downloads.sourceforge.net/polyglotman/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-incompatible-pointer-types.patch
)

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
