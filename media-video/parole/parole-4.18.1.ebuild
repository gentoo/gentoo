# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A simple Xfce4 media player using GStreamer"
HOMEPAGE="
	https://docs.xfce.org/apps/parole/start
	https://gitlab.xfce.org/apps/parole/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="libnotify taglib wayland X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	>=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.38:2
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	sys-apps/dbus
	>=x11-libs/gtk+-3.20:3[wayland?,X?]
	>=xfce-base/libxfce4ui-4.11:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.11:=
	>=xfce-base/xfconf-4.10:=
	libnotify? ( >=x11-libs/libnotify-0.7 )
	taglib? ( >=media-libs/taglib-1.6:0= )
	X? (
		>=x11-libs/libX11-1.6.7
	)
"
RDEPEND="
	${DEPEND}
	media-plugins/gst-plugins-meta:1.0
"
DEPEND+="
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/glib-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		# clutter backend does not work with new GTK+3 versions
		--disable-clutter
		$(use_enable taglib)
		$(use_enable libnotify notify-plugin)
		$(use_enable wayland)
		$(use_enable X x11)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
