# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Desktop manager for the Xfce desktop environment"
HOMEPAGE="
	https://docs.xfce.org/xfce/xfdesktop/start
	https://gitlab.xfce.org/xfce/xfdesktop/
"
SRC_URI="https://archive.xfce.org/src/xfce/${PN}/${PV%.*}/${P}.tar.xz"

# CC for /usr/share/backgrounds, see backgrounds/README.md
LICENSE="GPL-2+ CC-BY-SA-4.0"
SLOT="0"
IUSE="libnotify +thunar video wayland X"
REQUIRED_USE="|| ( wayland X )"

DEPEND="
	>=dev-libs/glib-2.72.0
	>=dev-libs/libyaml-0.2.5:=
	>=x11-libs/gtk+-3.24.0:3[wayland?,X?]
	>=xfce-base/garcon-4.18.0:=
	>=xfce-base/libxfce4ui-4.21.0:=[X(+)?]
	>=xfce-base/libxfce4util-4.18.0:=
	>=xfce-base/libxfce4windowing-4.20.6:=[X?]
	>=xfce-base/xfconf-4.19.3:=
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	thunar? (
		>=xfce-base/thunar-4.18.0:=
	)
	video? (
		>=media-libs/gstreamer-1.18.0
		media-plugins/gst-plugins-gtk
	)
	wayland? ( >=gui-libs/gtk-layer-shell-0.7.0 )
	X? ( >=x11-libs/libX11-1.6.7 )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-libs/glib
	>=dev-util/gdbus-codegen-2.80.5-r1
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddesktop-menu=enabled
		-Ddesktop-icons=true
		-Dfile-icons=true
		$(meson_feature thunar thunarx)
		$(meson_feature libnotify notifications)
		$(meson_feature X x11)
		$(meson_feature wayland)
		# only interactive tests
		-Dtests=false
		$(meson_use video video-backdrop)
	)

	if use video; then
		addpredict /dev
	fi
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
