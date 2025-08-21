# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Maybe a GNOME shell like dashboard for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfdashboard/start"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.66:2
	>=x11-libs/gtk+-3.22.0:3
	>=media-libs/clutter-1.24.0:1.0[gtk]
	>=media-libs/cogl-1.18.0:1.0
	>=x11-libs/libwnck-3.0:3
	>=x11-libs/libX11-1.6.7:=
	>=x11-libs/libXcomposite-0.2:=
	>=x11-libs/libXdamage-1.1.5:=
	>=x11-libs/libXinerama-1.1.4:=
	>=xfce-base/garcon-4.16.0:=
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dclutter-gdk=enabled
		# TODO: make these optional?
		-Dxcomposite=enabled
		-Dxdamage=enabled
		-Dxinerama=enabled
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
