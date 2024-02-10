# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit linux-info toolchain-funcs xdg-utils

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/phillipberndt/pqiv.git"
	inherit git-r3
else
	SRC_URI="https://github.com/phillipberndt/pqiv/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~riscv x86"
fi

DESCRIPTION="powerful GTK 3 based command-line image viewer with a minimal UI"
HOMEPAGE="https://github.com/phillipberndt/pqiv http://www.pberndt.com/Programme/Linux/pqiv/"

LICENSE="GPL-2"
SLOT="0"
IUSE="archive ffmpeg imagemagick pdf postscript webp"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/cairo-1.6
	x11-libs/gtk+:3
	archive? ( app-arch/libarchive:0= )
	ffmpeg? ( media-video/ffmpeg:0= )
	imagemagick? ( media-gfx/imagemagick:0= )
	pdf? ( app-text/poppler:0= )
	postscript? ( app-text/libspectre:0= )
	webp? ( media-libs/libwebp:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

doecho() {
	echo "$@"
	"$@" || die
}

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~INOTIFY_USER"
		linux-info_pkg_setup
	fi
}

src_configure() {
	local backends="gdkpixbuf"
	use archive && backends+=",archive,archive_cbx"
	use ffmpeg && backends+=",libav"
	use imagemagick && backends+=",wand"
	use pdf && backends+=",poppler"
	use postscript && backends+=",spectre"
	use webp && backends+=",webp"

	doecho ./configure \
		--backends-build=shared \
		--backends=${backends} \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--destdir="${ED}"
}

src_compile() {
	tc-export CC
	emake VERBOSE=1 CFLAGS="${CFLAGS}"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
