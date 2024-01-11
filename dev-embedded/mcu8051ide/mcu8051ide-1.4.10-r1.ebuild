# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Graphical IDE for microcontrollers based on 8051"
HOMEPAGE="https://sourceforge.net/projects/mcu8051ide/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

# The doxygen dependency is suspect, but it appears to be used at runtime.
RDEPEND="
	>=app-text/doxygen-1.7
	>=app-text/hunspell-1.3
	>=dev-embedded/sdcc-2.5[mcs51]
	>=dev-lang/tcl-8.5.9:*
	>=dev-lang/tk-8.5.9:*
	>=dev-tcltk/bwidget-1.8
	>dev-tcltk/itcl-3.3
	>=dev-tcltk/tcllib-1.11
	>=dev-tcltk/tclx-8.4
	>=dev-tcltk/tdom-0.8
	>=dev-tcltk/tkimg-1.4
	>=dev-util/indent-2.2
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/gzip"

PATCHES=(
	# Patches thanks to Debian
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-appdata.patch
	"${FILESDIR}"/${P}-desktop-file.patch
)

src_prepare() {
	cmake_src_prepare
	gunzip doc/man/mcu8051ide.1.gz || die
}

src_install() {
	cmake_src_install
	doman doc/man/mcu8051ide.1
}
