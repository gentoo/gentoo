# Copyright 2005-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
inherit toolchain-funcs

DESCRIPTION="Creates burnable CD images for SGI LiveCDs"
HOMEPAGE="ftp://ftp.linux-mips.org/pub/linux/mips/people/skylark/"
SRC_URI="https://dev.gentoo.org/~kumba/distfiles/${P}.tar.xz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~mips"

# sgibootcd is a small utility used to build the image that is burned to a
# CD and used to boot SGI systems.  Its compilation does not involve the
# external linker, 'ld', and thus this makes it difficult to reliably pass
# user LDFLAGS.  See Bug #725836.
QA_FLAGS_IGNORED="/usr/bin/sgibootcd"

src_compile() {
	local mycc="$(tc-getCC) ${CFLAGS}"

	# There is no Makefile, so check for an existing binary
	# and remove it if necessary
	[[ -f "${S}/sgibootcd" ]] && rm -f "${S}"/sgibootcd

	# Compile sgibootcd.c to a standalone executable.
	einfo "${mycc} sgibootcd.c -o sgibootcd"
	${mycc} sgibootcd.c -o sgibootcd
}

src_install() {
	dobin "${S}"/sgibootcd
}
