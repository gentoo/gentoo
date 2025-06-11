# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="WebRTC plugins for GStreamer"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=media-plugins/gst-plugins-sctp-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/webrtc-audio-processing-1.0:1[${MULTILIB_USEDEP}]
	>=net-libs/libnice-0.1.21[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

GST_PLUGINS_ENABLED="webrtc webrtcdsp"
GST_PLUGINS_BUILD_DIR="webrtc webrtcdsp"

PATCHES=(
	"${FILESDIR}/${PN}-1.26.1-disable-srtp-sctp-dtls-options.patch"
	"${FILESDIR}/0001-meson_fix_building-bad_tests_with_disabled_soundtouch.patch"
)

src_prepare() {
	default
	gstreamer_system_package \
		gstwebrtc_dep:gstreamer-webrtc \
		gstsctp_dep:gstreamer-sctp \
		gstbadaudio_dep:gstreamer-bad-audio
}

multilib_src_install() {
	# TODO: Fix this properly, see bug #907470 and bug #909079.
	insinto /usr/$(get_libdir)
	doins "${BUILD_DIR}"/ext/webrtc/libgstwebrtc.so
	doins "${BUILD_DIR}"/gst-libs/gst/webrtc/nice/libgstwebrtcnice-1.0.so*
	insinto /usr/include/gstreamer-1.0/gst/webrtc/nice
	doins "${S}"/gst-libs/gst/webrtc/nice/*.h
	gstreamer_multilib_src_install
}
