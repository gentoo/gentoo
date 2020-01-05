# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs xdg-utils

DESCRIPTION="Minimal image viewer designed for tiling window manager users"
HOMEPAGE="https://github.com/eXeC64/imv"
SRC_URI="https://github.com/eXeC64/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X +freeimage jpeg libnsgif png +svg test tiff wayland"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( X wayland )
"

RDEPEND="
	!sys-apps/renameutils
	media-libs/fontconfig
	media-libs/libsdl2
	media-libs/sdl2-ttf
	X? (
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libxkbcommon
		x11-libs/pango
	)
	freeimage? ( media-libs/freeimage )
	jpeg? ( media-libs/libjpeg-turbo )
	libnsgif? ( media-libs/libnsgif )
	png? ( media-libs/libpng )
	svg? ( gnome-base/librsvg )
	tiff? ( media-libs/tiff )
	wayland? ( dev-libs/wayland )
"
BDEPEND="
	app-text/asciidoc
	test? ( dev-util/cmocka )
"
DEPEND="
	${RDEPEND}
"

src_prepare() {
	default
	sed -i -e 's|pkg-config|$(PKG_CONFIG)|g' Makefile || die
}

src_configure() {
	tc-export PKG_CONFIG
	local WINDOWS
	if use X; then
		if ! use wayland; then
			WINDOWS=x11
		else
			WINDOWS=all
		fi
	else
		if use wayland; then
			WINDOWS=wayland
		fi
	fi

	BACKENDS=(
		BACKEND_FREEIMAGE=$(usex freeimage)
		BACKEND_JPEG=$(usex jpeg)
		BACKEND_LIBNSGIF=$(usex libnsgif)
		BACKEND_LIBPNG=$(usex png)
		BACKEND_LIBRSVG=$(usex svg)
		BACKEND_LIBTIFF=$(usex tiff)
		WINDOWS=${WINDOWS}
	)
}

src_compile() {
	emake ${BACKENDS[@]}
}

src_install() {
	emake ${BACKENDS[@]} DESTDIR="${D}" install
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
