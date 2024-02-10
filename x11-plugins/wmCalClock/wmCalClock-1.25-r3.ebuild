# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="WMaker DockApp: A Calendar clock with antialiased text"
HOMEPAGE="https://www.dockapps.net/wmcalclock"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ~mips ppc ppc64 ~sparc x86"
IUSE=""

S="${WORKDIR}/${P}/Src"

DOCS=( ../{BUGS,CHANGES,HINTS,README,TODO} )

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-gcc-10.patch
	)

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="-L/usr/$(get_libdir)/"
}
