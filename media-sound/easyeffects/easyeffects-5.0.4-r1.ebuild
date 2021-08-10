# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson

DESCRIPTION="Limiter, auto volume and many other plugins for PipeWire applications"
HOMEPAGE="https://github.com/wwmm/easyeffects/tree/pipewire-gstreamer-legacy"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/wwmm/easyeffects"
	EGIT_BRANCH="pipewire-gstreamer-legacy"
else
	SRC_URI="https://github.com/wwmm/easyeffects/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="bs2b calf rnnoise rubberband webrtc zamaudio"

DEPEND=">=dev-libs/boost-1.72:=
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
	>=media-video/pipewire-0.3.24[gstreamer]
	>=x11-libs/gtk+-3.20:3
	bs2b? ( >=media-plugins/gst-plugins-bs2b-1.12.5:1.0 )
	rnnoise? ( media-libs/rnnoise )"
RDEPEND="!media-sound/pulseeffects
	${DEPEND}
	gnome-extra/yelp
	>=media-libs/gst-plugins-good-1.12.5:1.0
	>=media-libs/lsp-plugins-1.1.24[lv2]
	>=media-plugins/gst-plugins-ladspa-1.12.5:1.0
	>=media-plugins/gst-plugins-lv2-1.12.5:1.0
	>=media-plugins/gst-plugins-pulse-1.12.5:1.0
	sys-apps/dbus
	calf? ( >=media-plugins/calf-0.90.1[lv2] )
	rubberband? ( media-libs/rubberband[ladspa] )
	webrtc? ( media-plugins/gst-plugins-webrtc )
	zamaudio? ( media-plugins/zam-plugins )"
# Only header files are used from libsamplerate so put it here rather than DEPEND
# to avoid unnecessary cross-compilation.
BDEPEND="dev-libs/appstream-glib
	dev-util/desktop-file-utils
	dev-util/itstool
	media-libs/libsamplerate
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-5.0.4-meson_no_automagic.patch
)

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
