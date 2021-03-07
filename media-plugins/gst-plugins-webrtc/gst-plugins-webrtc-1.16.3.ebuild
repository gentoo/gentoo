# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="WebRTC plugins for GStreamer"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-bad-${PV}:1.0[${MULTILIB_USEDEP}]
	>=media-libs/webrtc-audio-processing-0.2[${MULTILIB_USEDEP}]
	<media-libs/webrtc-audio-processing-0.4
	>=net-libs/libnice-0.1.14[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

GST_PLUGINS_BUILD="webrtc webrtcdsp"
GST_PLUGINS_BUILD_DIR="webrtc webrtcdsp"

src_prepare() {
	default
	gstreamer_system_link gst-libs/gst/webrtc:gstreamer-webrtc
	gstreamer_system_link gst-libs/gst/sctp:gstreamer-sctp
	gstreamer_system_link gst-libs/gst/audio:gstreamer-bad-audio
}
