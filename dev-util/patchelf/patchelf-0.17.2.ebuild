# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Small utility to modify the dynamic linker and RPATH of ELF executables"
HOMEPAGE="https://github.com/NixOS/patchelf"
SRC_URI="https://github.com/NixOS/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~riscv-linux ~x86-linux"
LICENSE="GPL-3"

src_prepare() {
	default
	rm src/elf.h || die

	sed -i \
		-e 's:-Werror::g' \
		configure.ac || die

	eautoreconf
}
