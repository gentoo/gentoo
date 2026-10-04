# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Zeroes out all free space on a filesystem"
HOMEPAGE="https://frippery.org/uml/"
SRC_URI="https://frippery.org/uml/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~riscv ~x86"

DEPEND="sys-fs/e2fsprogs"
RDEPEND="${DEPEND}"

# Bug #712582, fix compile in musl environments.
PATCHES=( "${FILESDIR}"/${PN}-include-sys_types.patch )

src_prepare() {
	default

	# Honor system CFLAGS.
	# Use pipes for the sed delimiter to resolve #710818.
	sed -i \
		-e "s|CC=gcc|CC=$(tc-getCC)\nCFLAGS=${CFLAGS}\nLDFLAGS=${LDFLAGS}|g" \
		-e "s|-o zerofree|\$(CFLAGS) \$(LDFLAGS) -o zerofree|g" \
		-e "/-lext2fs/{ s|-lext2fs||g; s|$| -lext2fs|g; }" \
		Makefile || die "Failed to sed the Makefile"
}

src_install() {
	# Install into /sbin
	into /
	dosbin zerofree
}
