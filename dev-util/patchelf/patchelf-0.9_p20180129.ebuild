# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools vcs-snapshot

DESCRIPTION="Small utility to modify the dynamic linker and RPATH of ELF executables"
HOMEPAGE="http://nixos.org/patchelf.html"
COMMIT=1fa4d36fead44333528cbee4b5c04c207ce77ca4
SRC_URI="https://github.com/NixOS/${PN^}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"

src_prepare() {
	default
	rm src/elf.h || die

	sed -i \
		-e 's:-Werror::g' \
		-e 's:parallel-tests:serial-tests:g' \
		configure.ac || die

	eautoreconf
}
