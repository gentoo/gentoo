# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Japanese handwriting recognition tool"
HOMEPAGE="https://fishsoup.net/software/kanjipad/"
SRC_URI="https://fishsoup.net/software/kanjipad/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

RDEPEND="
	app-accessibility/at-spi2-core:2
	x11-libs/gtk+:2
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-cflags.patch"
	"${FILESDIR}/${P}-underlinking.patch"
)

src_prepare() {
	default
	sed -i -e "s|PREFIX=/usr/local|PREFIX=/usr|" \
		-e "s|-DG.*DISABLE_DEPRECATED||g" Makefile || die "Fixing Makefile failed"
}

src_configure() {
	tc-export CC
}

src_install() {
	dobin kanjipad kpengine
	insinto /usr/share/kanjipad
	doins jdata.dat

	local DOCS=( ChangeLog README TODO jstroke/README-kanjipad )
	einstalldocs
}
