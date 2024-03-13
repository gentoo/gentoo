# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A hardware-independent library for executing real-mode x86 code"
HOMEPAGE="https://www.codon.org.uk/~mjg59/libx86/"
SRC_URI="https://www.codon.org.uk/~mjg59/${PN}/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm -ppc -riscv -sparc ~x86"

PATCHES=(
	# fix compile failure with linux-headers-2.6.26, bug 235599
	"${FILESDIR}"/${PN}-0.99-ifmask.patch
	# Patch for bugs #236888 and #456648
	"${FILESDIR}"/${P}-makefile.patch
	# Wider arch compatibility, bug #579682
	"${FILESDIR}"/${P}-x86emu.patch
	"${FILESDIR}"/${P}-c99.patch
)

src_configure() {
	tc-export AR CC
	append-cflags -fno-delete-null-pointer-checks #523276
}

src_compile() {
	emake $(usev !x86 BACKEND=x86emu) LIBRARY=shared shared
}

src_install() {
	emake \
		LIBDIR=/usr/$(get_libdir) \
		DESTDIR="${ED}" \
		install-header install-shared
}
