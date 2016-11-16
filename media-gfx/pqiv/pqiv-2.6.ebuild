# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit linux-info toolchain-funcs

DESCRIPTION="Modern rewrite of Quick Image Viewer"
HOMEPAGE="https://github.com/phillipberndt/pqiv http://www.pberndt.com/Programme/Linux/pqiv/"
SRC_URI="https://github.com/phillipberndt/pqiv/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg imagemagick kernel_linux libav pdf postscript"

RDEPEND=">=dev-libs/glib-2.8:2
	>=x11-libs/cairo-1.6
	x11-libs/gtk+:3
	ffmpeg? (
		!libav? ( media-video/ffmpeg:0= )
		libav? ( media-video/libav:0= )
	)
	imagemagick? ( media-gfx/imagemagick:0= )
	pdf? ( app-text/poppler:0= )
	postscript? ( app-text/libspectre:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( "README.markdown" )

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="~INOTIFY_USER"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default
	sed -i \
		-e "s:/lib/:/$(get_libdir)/:g" \
		GNUmakefile || die
}

src_configure() {
	local backends="gdkpixbuf"
	use ffmpeg || use libav && backends="${backends},libav"
	use imagemagick && backends="${backends},magick"
	use pdf && backends="${backends},poppler"
	use postscript && backends="${backends},spectre"

	./configure \
		--backends-build=shared \
		--backends=${backends} \
		--prefix="${EPREFIX}/usr" \
		--destdir="${ED}" \
		|| die
}

src_compile() {
	tc-export CC
	emake CFLAGS="${CFLAGS}"
}
