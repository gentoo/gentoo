# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="Desktop manager for the Xfce desktop environment"
HOMEPAGE="https://www.xfce.org/projects/"
SRC_URI="mirror://xfce/src/xfce/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug libnotify +thunar"

# src/xfdesktop-file-utils.c:#if GLIB_CHECK_VERSION (2, 38, 0)
RDEPEND=">=x11-libs/cairo-1.12:=
	>=dev-libs/glib-2.42:=
	>=x11-libs/gtk+-3.20:3=
	>=x11-libs/libwnck-3.14:3=
	x11-libs/libX11:=
	>=xfce-base/exo-0.11:=
	>=xfce-base/garcon-0.6:=
	>=xfce-base/libxfce4ui-4.13:=
	>=xfce-base/libxfce4util-4.12:=
	>=xfce-base/xfconf-4.12.1:=
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	thunar? (
		>=dev-libs/glib-2.38:=
		>=xfce-base/thunar-1.6:=[dbus]
		)"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable thunar file-icons)
		$(use_enable thunar thunarx)
		$(use_enable libnotify notifications)
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
