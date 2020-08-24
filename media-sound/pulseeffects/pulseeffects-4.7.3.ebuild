# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson

DESCRIPTION="Limiter, compressor, reverberation, equalizer auto volume effects for Pulseaudio"
HOMEPAGE="https://github.com/wwmm/pulseeffects"

if [[ ${PV} == *9999 ]];then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/wwmm/pulseeffects"
else
	SRC_URI="https://github.com/wwmm/pulseeffects/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="bs2b calf mda-lv2 rubberband"

#TODO: optional : lilv, zam-plugins (check from archlinux pkg)
RDEPEND="
	>=dev-libs/boost-1.41:=
	>=dev-cpp/glibmm-2.56.0
	>=dev-cpp/gtkmm-3.20:3.0
	>=dev-libs/glib-2.56:2
	>=dev-libs/libsigc++-2.10:2
	>=x11-libs/gtk+-3.18:3
	>=media-libs/lilv-0.24.2-r1
	>=media-libs/lsp-plugins-1.1.7[lv2]
	>=media-libs/gstreamer-1.12.0:1.0
	>=media-libs/gst-plugins-good-1.12.0:1.0
	>=media-libs/gst-plugins-bad-1.12.0:1.0
	bs2b? ( >=media-plugins/gst-plugins-bs2b-1.12.0:1.0 )
	>=media-plugins/gst-plugins-ladspa-1.12.0:1.0
	>=media-plugins/gst-plugins-lv2-1.12.0:1.0
	>=media-plugins/gst-plugins-pulse-1.12.0:1.0
	calf? ( >=media-plugins/calf-0.90.0[lv2] )
	mda-lv2? ( media-plugins/mda-lv2 )
	rubberband? ( media-libs/rubberband )
	>=media-libs/zita-convolver-3.0.0
	media-libs/libebur128
	media-sound/pulseaudio
	sys-apps/dbus"
# see 47a950b00c6db383ad07502a8fc396ecca98c1ce for dev-libs/appstream-glib
# and sys-devel/gettext depends reasoning
DEPEND="
	${RDEPEND}
	dev-libs/appstream-glib
	sys-devel/gettext
"
BDEPEND="
	>=sys-devel/gcc-7.3.0
	dev-util/itstool
	media-libs/libsamplerate
	virtual/pkgconfig
"

pkg_postinst() {
	gnome2_gconf_install
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_gconf_uninstall
	gnome2_schemas_update
	xdg_icon_cache_update
}
