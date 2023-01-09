# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="remove #ifdef'ed lines from a file while otherwise leaving the file alone"
HOMEPAGE="https://dotat.at/prog/unifdef/"
SRC_URI="https://dotat.at/prog/unifdef/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

PATCHES=( "${FILESDIR}"/${P}-tests.patch )

DOCS=( README )

src_prepare() {
	sed -i "/^prefix/s:=.*:=${EPREFIX}/usr:" Makefile || die
	tc-export CC
	default
}
