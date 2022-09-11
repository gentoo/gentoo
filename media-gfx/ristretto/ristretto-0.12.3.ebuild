# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A fast and lightweight picture viewer for Xfce"
HOMEPAGE="https://docs.xfce.org/apps/ristretto/start"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.46:2
	media-libs/libexif:0=
	sys-apps/file
	x11-libs/cairo:0
	>=x11-libs/gtk+-3.22:3
	x11-libs/libX11:0=
	>=xfce-base/libxfce4ui-4.16:0=
	>=xfce-base/libxfce4util-4.16:0=
	>=xfce-base/xfconf-4.12.1:0=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
"

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
