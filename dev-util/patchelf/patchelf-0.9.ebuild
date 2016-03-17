# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Small utility to modify the dynamic linker and RPATH of ELF executables"
HOMEPAGE="http://nixos.org/patchelf.html"
SRC_URI="http://releases.nixos.org/${PN}/${P}/${P}.tar.bz2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
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
