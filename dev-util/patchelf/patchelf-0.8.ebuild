# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/patchelf/patchelf-0.8.ebuild,v 1.5 2015/06/24 10:55:41 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Small utility to modify the dynamic linker and RPATH of ELF executables"
HOMEPAGE="http://nixos.org/patchelf.html"
SRC_URI="http://releases.nixos.org/${PN}/${P}/${P}.tar.bz2"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE=""

AUTOTOOLS_IN_SOURCE_BUILD=1

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
