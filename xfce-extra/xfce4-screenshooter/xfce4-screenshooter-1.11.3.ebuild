# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Xfce4 screenshooter application and panel plugin"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-screenshooter/start
	https://gitlab.xfce.org/apps/xfce4-screenshooter/
"
SRC_URI="
	https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~loong ppc ppc64 ~riscv ~sparc ~x86"
IUSE="X wayland"
REQUIRED_USE="|| ( X wayland )"

# TODO: remove exo when we dep on libxfce4ui >= 4.21.0
DEPEND="
	>=dev-libs/glib-2.66.0
	>=x11-libs/gtk+-3.24.0:3[X?,wayland?]
	>=x11-libs/pango-1.44.0
	>=xfce-base/exo-4.18.0:=
	>=xfce-base/xfce4-panel-4.18.0:=
	>=xfce-base/libxfce4util-4.18.0:=
	>=xfce-base/libxfce4ui-4.18.0:=
	>=xfce-base/xfconf-4.18.0:=
	wayland? (
		>=dev-libs/wayland-1.20
		>=gui-libs/gtk-layer-shell-0.7.0
	)
	X? (
		>=x11-libs/libX11-1.6.7
		>=x11-libs/libXext-1.0.0
		>=x11-libs/libXfixes-4.0.0
		>=x11-libs/libXi-1.7.8
		x11-libs/libXtst
	)
"
RDEPEND="
	${DEPEND}
"
DEPEND+="
	wayland? (
		>=dev-libs/wayland-protocols-1.37
	)
"
BDEPEND="
	dev-util/glib-utils
	sys-apps/help2man
	sys-devel/gettext
	virtual/pkgconfig
	wayland? (
		>=dev-util/wayland-scanner-1.20
	)
"

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature wayland)
		$(meson_feature X xfixes)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
