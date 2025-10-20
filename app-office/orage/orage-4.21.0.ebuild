# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A calendar application for Xfce"
HOMEPAGE="
	https://docs.xfce.org/apps/orage/start
	https://gitlab.xfce.org/apps/orage/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="X libnotify"

DEPEND="
	>=dev-libs/glib-2.74.0
	>=dev-libs/libical-3.0.16:=
	>=x11-libs/gtk+-3.24.0:3
	x11-libs/libX11
	>=xfce-base/libxfce4ui-4.20.0:=
	>=xfce-base/libxfce4util-4.20.0:=
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature libnotify)
		-Darchive=true
		$(meson_use X x11-tray-icon)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
