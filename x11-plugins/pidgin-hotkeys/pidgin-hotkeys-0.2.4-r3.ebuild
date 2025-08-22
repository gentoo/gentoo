# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Pidgin plugin to define global hotkeys for various actions"
HOMEPAGE="https://sourceforge.net/projects/pidgin-hotkeys/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	net-im/pidgin:=[gui]
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fix_gcc15.patch
	"${FILESDIR}"/${P}-fix_cflags.patch
)

src_prepare() {
	default
	# configure.ac patched
	eautoconf
}

src_install() {
	default

	find "${D}" -type f -name '*.la' -delete || die
}
