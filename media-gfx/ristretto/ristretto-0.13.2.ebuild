# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A fast and lightweight picture viewer for Xfce"
HOMEPAGE="
	https://docs.xfce.org/apps/ristretto/start
	https://gitlab.xfce.org/apps/ristretto/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~sparc x86"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=media-libs/libexif-0.6.0:0=
	sys-apps/file
	>=x11-libs/cairo-1.10.0:0
	>=x11-libs/gtk+-3.22.0:3
	>=x11-libs/libX11-1.6.7:0=
	>=xfce-base/libxfce4ui-4.16.0:0=
	>=xfce-base/libxfce4util-4.16.0:0=
	>=xfce-base/xfconf-4.12.1:0=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
