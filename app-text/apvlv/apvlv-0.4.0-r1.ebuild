# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake desktop

DESCRIPTION="Alf's PDF/DJVU/EPUB Viewer like Vim"
HOMEPAGE="https://github.com/naihe2010/apvlv/"
SRC_URI="https://github.com/naihe2010/apvlv/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug djvu"

RDEPEND="
	app-text/ebook-tools
	>=app-text/poppler-0.5.0:=[cairo,xpdf-headers(+)]
	dev-libs/glib:2
	dev-libs/libxml2
	net-libs/webkit-gtk:4=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/pango
	djvu? ( app-text/djvu )
"

DEPEND="${RDEPEND}
	app-text/ghostscript-gpl
	media-libs/freetype
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-cmake-cxxflags.patch
	"${FILESDIR}"/${P}-icon.patch
)
src_prepare() {
	cmake_src_prepare
}
src_configure() {
	local mycmakeargs=(
		-DAPVLV_WITH_DJVU=$(usex djvu)
		-DAPVLV_ENABLE_DEBUG=$(usex debug)
		-DAPVLV_WITH_TXT=ON
		-DDOCDIR="/usr/share/doc/${PF}"
	)
	cmake_src_configure
}
src_install() {
	cmake_src_install
	newicon -s 32 icons/pdf.png ${PN}.png
}
