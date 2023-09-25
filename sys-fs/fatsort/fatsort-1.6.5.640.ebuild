# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Sorts files on FAT16/32 partitions, ideal for basic audio players"
HOMEPAGE="http://fatsort.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	default

	sed -i -e 's|/usr/local|/usr|g' \
		$(find ./ -name Makefile || die) || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		man
}

src_test() {
	# Tests require root permissions and mounting filesystems which does
	# not work inside the ebuild environment
	true
}
