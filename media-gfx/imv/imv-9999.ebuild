# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 meson xdg-utils

DESCRIPTION="Minimal image viewer designed for tiling window manager users"
LICENSE="MIT-with-advertising"
HOMEPAGE="https://github.com/eXeC64/imv"
EGIT_REPO_URI="https://github.com/eXeC64/imv"

KEYWORDS=""
SLOT="0"
IUSE="X +freeimage +png jpeg svg gif heif test tiff wayland"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( X wayland )
"

RDEPEND="
	!sys-apps/renameutils
	dev-libs/icu:=
	media-libs/fontconfig
	media-libs/libsdl2
	media-libs/sdl2-ttf
	X? (
		virtual/glu
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libxkbcommon[X]
		x11-libs/pango
	)
	freeimage? ( media-libs/freeimage[png?,jpeg?,tiff?] )
	!freeimage? (
		jpeg? ( media-libs/libjpeg-turbo )
		png? ( media-libs/libpng )
		tiff? ( media-libs/tiff )
	)
	gif? ( media-libs/libnsgif )
	heif? ( media-libs/libheif )
	svg? ( >=gnome-base/librsvg-2.44 )
	wayland? ( dev-libs/wayland )
"
BDEPEND="
	app-text/asciidoc
	test? ( dev-util/cmocka )
"
DEPEND="
	${RDEPEND}
"

src_configure() {
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

	if ! use test; then
		sed -i -e '/^dep_cmocka/,/^endforeach$/d' meson.build || die
	fi

	local emesonargs=(
		$(meson_feature freeimage)
		$(meson_feature gif libnsgif)
		$(meson_feature heif libheif)
		$(meson_feature svg librsvg)
		$(usex freeimage -Dlibjpeg=disabled -Dlibjpeg=enabled)
		$(usex freeimage -Dlibpng=disabled -Dlibjpeg=enabled)
		$(usex freeimage -Dlibtiff=disabled -Dlibjpeg=enabled)
		-Dwindows=$WINDOWS
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
