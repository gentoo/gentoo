# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eXeC64/imv.git"
else
	SRC_URI="https://github.com/eXeC64/imv/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Minimal image viewer designed for tiling window manager users"
HOMEPAGE="https://github.com/eXeC64/imv"

LICENSE="MIT-with-advertising"
SLOT="0"
IUSE="+X +freeimage gif heif jpeg png svg test tiff wayland"
REQUIRED_USE="|| ( X wayland )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/icu:=
	dev-libs/inih
	media-libs/libglvnd[X?]
	x11-libs/libxkbcommon[X?]
	x11-libs/pango
	X? (
		x11-libs/libX11
		x11-libs/libxcb:=
	)
	freeimage? ( media-libs/freeimage )
	gif? ( media-libs/libnsgif )
	heif? ( media-libs/libheif:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	png? ( media-libs/libpng:= )
	svg? ( >=gnome-base/librsvg-2.44 )
	tiff? ( media-libs/tiff )
	wayland? ( dev-libs/wayland )
	!sys-apps/renameutils"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="
	app-text/asciidoc
	wayland? ( dev-util/wayland-scanner )"

PATCHES=(
	"${FILESDIR}/${PN}-4.2.0-add-string-inc.patch"
	"${FILESDIR}/${PN}-4.2.0-wayland-roundtrip-after-scale.patch"
)

src_prepare() {
	default

	# allow building with libglvnd[-X]
	if ! use X; then
		sed -i "/dependency('gl')/s/gl/opengl/" meson.build || die
	fi

	# glu isn't used by anything
	sed -i "/dependency('glu')/d" meson.build || die
}

src_configure() {
	local windows=all
	use X || windows=wayland
	use wayland || windows=x11

	local emesonargs=(
		$(meson_feature freeimage)
		$(meson_feature gif libnsgif)
		$(meson_feature heif libheif)
		$(meson_feature jpeg libjpeg)
		$(meson_feature png libpng)
		$(meson_feature svg librsvg)
		$(meson_feature test)
		$(meson_feature tiff libtiff)
		-Dwindows=${windows}
	)
	meson_src_configure
}
