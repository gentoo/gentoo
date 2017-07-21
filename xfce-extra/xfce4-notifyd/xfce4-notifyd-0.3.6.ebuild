# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Notification daemon for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/applications/xfce4-notifyd"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.42:2=
	>=x11-libs/gtk+-3.14:3=
	>=x11-libs/libnotify-0.7:=
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfconf-4.10:="
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README TODO )

pkg_postinst() {
	GNOME2_ECLASS_ICONS="usr/share/icons/hicolor" \
	gnome2_icon_cache_update
}

pkg_postrm() {
	GNOME2_ECLASS_ICONS="usr/share/icons/hicolor" \
	gnome2_icon_cache_update
}
