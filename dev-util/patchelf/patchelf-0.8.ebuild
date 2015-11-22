# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Small utility to modify the dynamic linker and RPATH of ELF executables"
HOMEPAGE="http://nixos.org/patchelf.html"
SRC_URI="http://releases.nixos.org/${PN}/${P}/${P}.tar.bz2"

SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE=""

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${P}-dash.patch )

src_prepare() {
	rm src/elf.h || die
	sed -e 's:-Werror::g' -i configure.ac || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=( --docdir="${EPREFIX}"/usr/share/doc/${PF} )
	autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_test -j1
}
