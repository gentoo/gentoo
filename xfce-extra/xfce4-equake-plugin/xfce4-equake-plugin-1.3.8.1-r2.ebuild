# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Panel plug-in that displays information about earthquakes at regular intervals"
HOMEPAGE="http://www.e-quake.org/"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*.*}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2:=
	x11-libs/gtk+:2=
	x11-libs/libX11:=
	<xfce-base/libxfce4ui-4.15:=[gtk2(+)]
	>=xfce-base/libxfce4util-4.10:=
	<xfce-base/xfce4-panel-4.15:=[gtk2(+)]"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_postinst() {
	GNOME2_ECLASS_ICONS="usr/share/icons/hicolor" \
	gnome2_icon_cache_update
}

pkg_postrm() {
	GNOME2_ECLASS_ICONS="usr/share/icons/hicolor" \
	gnome2_icon_cache_update
}
