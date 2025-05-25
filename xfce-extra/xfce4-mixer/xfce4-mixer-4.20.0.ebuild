# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A volume control application and panel plugin for Xfce"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-mixer/start
	https://gitlab.xfce.org/apps/xfce4-mixer/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa +keybinder pulseaudio sndio"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=media-libs/gstreamer-1.0:1.0
	>=x11-libs/gtk+-3.22.0:3
	>=xfce-base/libxfce4ui-4.16.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.16.0:=
	>=xfce-base/xfce4-panel-4.16.0:=
	>=xfce-base/xfconf-4.16.0:=
	alsa? ( >=media-libs/alsa-lib-0.9:= )
	keybinder? ( >=dev-libs/keybinder-0.3:3 )
	sndio? ( >=media-sound/sndio-1.7.0 )
	pulseaudio? ( >=media-libs/libpulse-0.9.19[glib] )
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
		$(meson_feature keybinder)
		$(meson_feature pulseaudio pulse)
		$(meson_feature alsa)
		$(meson_feature sndio)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
