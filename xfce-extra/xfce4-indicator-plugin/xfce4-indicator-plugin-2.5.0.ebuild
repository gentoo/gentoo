# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A panel plugin that uses indicator-applet to show new messages"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-indicator-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-indicator-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

DEPEND="
	>=dev-libs/ayatana-ido-0.4.0
	>=dev-libs/glib-2.50.0
	>=dev-libs/libayatana-indicator-0.5.0:3
	>=x11-libs/gtk+-3.22.0:3
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.16.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
"
RDEPEND="
	${DEPEND}
"
# dev-libs/glib for glib-compile-resources
BDEPEND="
	dev-libs/glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dlibayatana-ido=enabled
		-Dindicator-application=enabled
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
