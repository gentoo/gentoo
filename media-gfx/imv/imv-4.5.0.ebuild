# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Minimal image viewer designed for tiling window manager users"
HOMEPAGE="https://sr.ht/~exec64/imv/"
SRC_URI="https://git.sr.ht/~exec64/imv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE="+X +freeimage heif icu jpeg jpegxl png svg test tiff wayland"
REQUIRED_USE="|| ( X wayland )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/glib:2
	dev-libs/inih
	media-libs/libglvnd[X?]
	x11-libs/cairo
	x11-libs/libxkbcommon[X?]
	x11-libs/pango
	X? (
		x11-libs/libX11
		x11-libs/libxcb:=
	)
	freeimage? ( media-libs/freeimage )
	heif? ( media-libs/libheif:= )
	icu? ( dev-libs/icu:= )
	!icu? ( >=dev-libs/libgrapheme-2:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpegxl? ( media-libs/libjxl:= )
	png? ( media-libs/libpng:= )
	svg? ( >=gnome-base/librsvg-2.44:2 )
	tiff? ( media-libs/tiff:= )
	wayland? ( dev-libs/wayland )
	!sys-apps/renameutils
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
	test? ( dev-util/cmocka )
"
BDEPEND="
	app-text/asciidoc
	wayland? ( dev-util/wayland-scanner )
"

src_prepare() {
	default

	# if wayland-only, don't automagic on libGL and force libOpenGL
	if use !X; then
		sed -i "/dependency('gl'/{s/'gl'/'opengl'/;s/false/true/}" meson.build || die
	fi

	# glu isn't used by anything
	sed -i "/dependency('glu')/d" meson.build || die
}

src_configure() {
	local emesonargs=(
		$(meson_feature freeimage)
		$(meson_feature heif libheif)
		$(meson_feature jpeg libjpeg)
		$(meson_feature jpegxl libjxl)
		$(meson_feature png libpng)
		$(meson_feature svg librsvg)
		$(meson_feature test)
		$(meson_feature tiff libtiff)
		-Dunicode=$(usex icu{,} grapheme)
		-Dwindows=$(usex X $(usex wayland all x11) wayland)

		# incompatible with >=libnsgif-1.0.0 and patches could use a
		# proper review before using (upstream is currently inactive)
		# See: https://github.com/gentoo/gentoo/pull/44086
		# (note that can still view non-animated gif with USE=freeimage)
		-Dlibnsgif=disabled
	)

	meson_src_configure
}
