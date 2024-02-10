# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="A volume control application and panel plugin for Xfce"
HOMEPAGE="
	https://docs.xfce.org/apps/xfce4-mixer/start
	https://gitlab.xfce.org/apps/xfce4-mixer/
"
SRC_URI="https://archive.xfce.org/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa +keybinder pulseaudio sndio"

DEPEND="
	>=dev-libs/glib-2.50.0
	>=media-libs/gstreamer-1.0:1.0
	>=x11-libs/gtk+-3.22.0:3
	>=x11-libs/libnotify-0.7
	>=xfce-base/libxfce4ui-4.12.0:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.12.0:=
	>=xfce-base/xfce4-panel-4.14.0:=
	>=xfce-base/xfconf-4.12.0:=
	alsa? ( >=media-libs/alsa-lib-0.9:= )
	keybinder? ( >=dev-libs/keybinder-0.3:3 )
	sndio? ( >=media-sound/sndio-1.7.0 )
	pulseaudio? ( media-libs/libpulse[glib] )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_enable alsa)
		$(use_enable keybinder)
		$(use_enable pulseaudio pulse)
		$(use_enable sndio)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
