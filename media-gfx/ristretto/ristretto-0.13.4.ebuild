# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A fast and lightweight picture viewer for Xfce"
HOMEPAGE="
	https://docs.xfce.org/apps/ristretto/start
	https://gitlab.xfce.org/apps/ristretto/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE="X"

# TODO: drop exo when we depend on >=libxfce4ui-4.21.0
DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=media-libs/libexif-0.6.0:0=
	sys-apps/file
	>=x11-libs/cairo-1.10.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/exo-4.16.0:=
	>=xfce-base/libxfce4ui-4.16.0:=
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=

	X? (
		>=x11-libs/libX11-1.6.7:=
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_feature X libx11)
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
