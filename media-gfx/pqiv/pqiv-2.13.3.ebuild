# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic linux-info toolchain-funcs xdg

DESCRIPTION="A powerful GTK 3 based command-line image viewer with a minimal UI"
HOMEPAGE="https://github.com/phillipberndt/pqiv https://www.pberndt.com/Programme/Linux/pqiv/"
SRC_URI="https://github.com/phillipberndt/pqiv/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="archive ffmpeg imagemagick pdf postscript webp"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/cairo-1.6
	>=x11-libs/gdk-pixbuf-2.2:2
	x11-libs/gtk+:3
	>=x11-libs/pango-1.10
	X? ( x11-libs/libX11 )
	archive? ( app-arch/libarchive:0= )
	ffmpeg? ( media-video/ffmpeg:0= )
	imagemagick? ( media-gfx/imagemagick:0= )
	pdf? ( app-text/poppler:0=[cairo] )
	postscript? ( app-text/libspectre:0= )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES="${FILESDIR}/${P}-scale-montage-view.patch"

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~INOTIFY_USER"
		linux-info_pkg_setup
	fi
}

src_configure() {
	local backends=(
		"gdkpixbuf"
		$(usev archive "archive")
		$(usev archive "archive_cbx")
		$(usev ffmpeg "libav")
		$(usev imagemagick "wand")
		$(usev pdf "poppler")
		$(usev postscript "spectre")
		$(usev webp "webp")
	)
	local myconf=(
		--backends-build=shared
		--backends=$(printf "%s," "${backends[@]}")
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
	)
	edo ./configure "${myconf[@]}"
}

src_compile() {
	tc-export CC
	emake VERBOSE=1 CFLAGS="${CFLAGS}"
}
