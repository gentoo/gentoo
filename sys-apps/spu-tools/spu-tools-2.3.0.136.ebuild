# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_P="${P/_p/-}"

DESCRIPTION="CELL spu ps and top alike utilities"
HOMEPAGE="https://sourceforge.net/projects/libspe"
SRC_URI="mirror://sourceforge/libspe/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}/src"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc ppc64"

RDEPEND="
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-buildsystem.patch
	"${FILESDIR}"/${P}-format-security.patch
)

src_configure() {
	tc-export CC
	append-cppflags -std=gnu89
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	export LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}
