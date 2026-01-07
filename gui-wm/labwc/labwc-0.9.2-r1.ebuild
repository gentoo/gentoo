# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Openbox alternative for wayland"
HOMEPAGE="https://github.com/labwc/labwc https://labwc.github.io/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/labwc/labwc"
else
	SRC_URI="https://github.com/labwc/labwc/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="X icons nls svg test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/wayland-1.19
	dev-libs/glib:2
	dev-libs/libinput:=
	dev-libs/libxml2:2
	gui-libs/wlroots:0.19[X?,libinput]
	media-libs/libpng:=
	x11-libs/cairo[X?]
	x11-libs/libdrm:=
	x11-libs/libxkbcommon[X?]
	x11-libs/pango[X?]
	x11-libs/pixman
	X? (
		x11-base/xwayland
		x11-libs/libxcb:0=
		x11-libs/xcb-util-wm
	)
	icons? ( gui-libs/libsfdo )
	nls? ( sys-devel/gettext )
	svg? ( gnome-base/librsvg:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/scdoc
	>=dev-libs/wayland-protocols-1.35
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? ( dev-util/cmocka )
"

src_configure() {
	local emesonargs=(
		-Dman-pages=enabled
		$(meson_feature X xwayland)
		$(meson_feature nls)
		$(meson_feature svg)
		$(meson_feature icons icon)
		$(meson_feature test)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	mv "${ED}"/usr/share/doc/${PN} "${ED}"/usr/share/doc/${PF} || die
}
