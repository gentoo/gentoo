# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

DESCRIPTION="Small utility to modify the dynamic linker and RPATH of ELF executables"
HOMEPAGE="https://github.com/NixOS/patchelf"
SRC_URI="https://github.com/NixOS/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-glibc-dt-mips-xhash.patch
)

src_prepare() {
	rm src/elf.h || die
	default

	sed -i \
		-e 's:-Werror::g' \
		configure.ac || die

	eautoreconf
}
