# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo linux-info toolchain-funcs xdg

DESCRIPTION="A powerful GTK 3 based command-line image viewer with a minimal UI"
HOMEPAGE="https://github.com/phillipberndt/pqiv https://www.pberndt.com/Programme/Linux/pqiv/"
SRC_URI="https://github.com/phillipberndt/pqiv/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"
IUSE="archive ffmpeg imagemagick pdf postscript webp"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/cairo-1.6
	>=x11-libs/gdk-pixbuf-2.2:2
	x11-libs/gtk+:3
	>=x11-libs/pango-1.10
	archive? ( app-arch/libarchive:0= )
	ffmpeg? ( media-video/ffmpeg:0= )
	imagemagick? ( media-gfx/imagemagick:0= )
	pdf? ( app-text/poppler:0=[cairo] )
	postscript? ( app-text/libspectre:0= )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~INOTIFY_USER"
		linux-info_pkg_setup
	fi
}

src_configure() {
	local backends=(
		"gdkpixbuf"
		$(usex archive "archive" "")
		$(usex archive "archive_cbx" "")
		$(usex ffmpeg "libav" "")
		$(usex imagemagick "wand" "")
		$(usex pdf "poppler" "")
		$(usex postscript "spectre" "")
		$(usex webp "webp" "")
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
