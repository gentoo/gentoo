# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="GTK-2.0 Theme Switcher"
HOMEPAGE="http://plasmasturm.org/programs/gtk-chtheme/"
SRC_URI="http://plasmasturm.org/programs/gtk-chtheme/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-implicit.patch
	"${FILESDIR}"/${P}-asneeded.patch  # Fix forced as-needed, bug #248655
	"${FILESDIR}"/${P}-qgtkstyle.patch # Make it work with qgtkstyle, bug #250504
)

src_prepare() {
	default

	# QA: stop Makefile from stripping the binaries
	sed -i -e "s:strip:true:" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${ED}" install
	einstalldocs
}
