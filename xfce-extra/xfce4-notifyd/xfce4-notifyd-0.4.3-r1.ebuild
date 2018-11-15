# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Notification daemon for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfce4-notifyd"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2 -> ${P}-r1.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.42:2=
	>=x11-libs/gtk+-3.14:3=
	>=x11-libs/libnotify-0.7:=
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfce4-panel-4.12:=
	>=xfce-base/xfconf-4.10:="
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	# DBUS_BINDING_TOOL is not used anymore
	# https://bugzilla.xfce.org/show_bug.cgi?id=14835
	econf DBUS_BINDING_TOOL=$(type -P false)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
