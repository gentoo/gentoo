# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A weather plug-in for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/panel-plugins/xfce4-weather-plugin/start
	https://gitlab.xfce.org/panel-plugins/xfce4-weather-plugin/
"
SRC_URI="
	https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv x86"
IUSE="upower"

DEPEND="
	>=dev-libs/glib-2.64.0
	>=dev-libs/json-c-0.13.1:=
	>=dev-libs/libxml2-2.4.0:=
	>=net-libs/libsoup-3.0.0:3.0[ssl]
	>=x11-libs/gtk+-3.22.0
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	upower? ( >=sys-power/upower-0.99.0 )
"
RDEPEND="
	${DEPEND}
"
# dev-libs/glib for glib-compile-resources
BDEPEND="
	dev-libs/glib
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature upower upower-glib)
		-Dgeonames-username=Gentoo
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
