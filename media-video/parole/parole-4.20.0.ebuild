# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A simple Xfce4 media player using GStreamer"
HOMEPAGE="
	https://docs.xfce.org/apps/parole/start
	https://gitlab.xfce.org/apps/parole/
"
SRC_URI="
	https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 arm arm64 ~loong ~mips ~ppc ~ppc64 ~riscv x86"
IUSE="gtk-doc libnotify taglib wayland X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	>=dev-libs/dbus-glib-0.70
	>=dev-libs/glib-2.38.0:2
	>=media-libs/gstreamer-1.0.0:1.0
	>=media-libs/gst-plugins-base-1.0.0:1.0
	>=sys-apps/dbus-0.60
	>=x11-libs/gtk+-3.22.0:3[wayland?,X?]
	>=xfce-base/libxfce4ui-4.16.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	libnotify? ( >=x11-libs/libnotify-0.7.8 )
	taglib? ( >=media-libs/taglib-1.4:0= )
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
# dev-libs/dbus-glib for dbus-binding-tool
# dev-libs/glib for glib-compile-resources
BDEPEND="
	dev-libs/dbus-glib
	>=dev-libs/glib-2.38.0:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gtk-doc
	)
"

src_configure() {
	local emesonargs=(
		$(meson_feature X x11)
		$(meson_feature wayland)
		$(meson_feature taglib)
		-Dmpris2-plugin=enabled
		$(meson_feature libnotify notify-plugin)
		-Dtray-plugin=enabled
		$(meson_use gtk-doc)
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
