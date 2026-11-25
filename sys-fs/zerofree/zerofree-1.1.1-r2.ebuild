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

PATCHES=(
	# Bug #712582, fix compile in musl environments.
	"${FILESDIR}"/${PN}-include-sys_types.patch
	"${FILESDIR}"/${PN}-respect-flags.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	# Install into /sbin
	into /
	dosbin zerofree
}
