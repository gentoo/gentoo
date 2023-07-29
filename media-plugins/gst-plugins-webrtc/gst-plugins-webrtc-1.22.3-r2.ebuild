# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="WebRTC plugins for GStreamer"
KEYWORDS="~amd64"

# == ext/webrtc/meson.build
# dev-libs/glib (eclass): gio_dep
# net-libs/libnice: libnice_dep
# media-libs/gst-plugins-base: gstbase_dep, gstsdp_dep, gstapp_dep, gstrtp_dep
# media-plugins/gst-plugins-sctp: gstsctp_dep
# == ext/webrtcdsp/meson.build
# media-libs/gst-plugins-base: gstbase_dep, gstaudio_dep
# media-libs/gst-plugins-bad: gstbadaudio_dep
# media-libs/webrtc-audio-processing: webrtc_dep
# (android): gnustl_dep
# == gst-libs/gst/webrtc/meson.build
# media-libs/gst-plugins-base: gstbase_dep, gstsdp_dep
RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-bad-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-plugins/gst-plugins-sctp-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/webrtc-audio-processing-0.2:0[${MULTILIB_USEDEP}]
	<media-libs/webrtc-audio-processing-0.4:0
	>=net-libs/libnice-0.1.21[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

GST_PLUGINS_ENABLED="webrtc webrtcdsp"
GST_PLUGINS_BUILD_DIR="webrtc webrtcdsp"

src_prepare() {
	default
	gstreamer_system_package gstwebrtc_dep:gstreamer-webrtc
	gstreamer_system_package gstsctp_dep:gstreamer-sctp
	gstreamer_system_package gstbadaudio_dep:gstreamer-bad-audio
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
