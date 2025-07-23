# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson

DESCRIPTION="Limiter, compressor, reverberation, equalizer auto volume effects for Pulseaudio"
HOMEPAGE="https://github.com/wwmm/easyeffects/tree/pulseaudio-legacy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wwmm/easyeffects"
	EGIT_BRANCH="pulseaudio-legacy"
else
	SRC_URI="https://github.com/wwmm/easyeffects/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="bs2b calf +doc rnnoise rubberband webrtc zamaudio"

COMMON="dev-libs/boost:=
	>=dev-cpp/glibmm-2.56.0:2
	>=dev-cpp/gtkmm-3.24:3.0
	>=dev-libs/glib-2.56:2
	>=dev-libs/libsigc++-2.10:2
	>=media-libs/gstreamer-1.12.5:1.0
	media-libs/gst-plugins-base
	>=media-libs/gst-plugins-bad-1.12.5:1.0
	media-libs/libebur128
	media-libs/libsndfile
	>=media-libs/lilv-0.24.2-r1
	>=media-libs/zita-convolver-3.0.0
	media-sound/pulseaudio
	>=x11-libs/gtk+-3.20:3
	bs2b? ( >=media-plugins/gst-plugins-bs2b-1.12.5:1.0 )
	rnnoise? ( media-libs/rnnoise )"
# Only header files are used from libsamplerate
DEPEND="${COMMON}
	media-libs/libsamplerate"
RDEPEND="!media-sound/easyeffects
	${COMMON}
	>=media-libs/gst-plugins-good-1.12.5:1.0
	>=media-libs/lsp-plugins-1.1.24[lv2]
	>=media-plugins/gst-plugins-ladspa-1.12.5:1.0
	>=media-plugins/gst-plugins-lv2-1.12.5:1.0
	>=media-plugins/gst-plugins-pulse-1.12.5:1.0
	sys-apps/dbus
	calf? ( >=media-plugins/calf-0.90.1[lv2] )
	doc? ( gnome-extra/yelp )
	rubberband? ( media-libs/rubberband[ladspa] )
	webrtc? ( media-plugins/gst-plugins-webrtc )
	zamaudio? ( media-plugins/zam-plugins )"
BDEPEND="dev-libs/appstream-glib
	dev-util/desktop-file-utils
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8.7-meson_no_automagic.patch
	"${FILESDIR}"/${PN}-4.8.7-boost-1.85.patch
	"${FILESDIR}"/${PN}-4.8.7-boost-1.88.patch
)

S="${WORKDIR}"/easyeffects-${PV}

src_configure() {
	local emesonargs=(
		$(meson_feature bs2b)
		$(meson_feature rnnoise)
	)
	meson_src_configure
}

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
