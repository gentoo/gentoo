# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Classic compress & uncompress programs for .Z (LZW) files"
HOMEPAGE="https://vapier.github.io/ncompress/"
SRC_URI="https://github.com/vapier/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0-c23.patch
)

src_prepare() {
	default
	# First sed expression replaces hardlinking with
	# symlinking. Second sed expression fixes the symlink target
	# to use relative path to a file in the same directory as the
	# symlink (so point to compress instead of
	# $(DESTDIR)$(BINDIR)/compress).
	sed -i \
		-e 's:\bln :ln -s :' \
		-e 's:\(\bln [^$]*\)\$(DESTDIR)\$(BINDIR)/:\1:' \
		Makefile.def || die
}

src_configure() {
	tc-export CC
}

src_install() {
	emake install_core DESTDIR="${ED}" PREFIX="/usr"
	dodoc Acknowleds Changes LZW.INFO README.md
}
