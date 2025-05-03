# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="Smooth Streaming plugin for GStreamer"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND=">=dev-libs/libxml2-2.9.1-r4:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	gstreamer_system_package gstcodecparsers_dep:gstreamer-codecparsers
	gstreamer_system_library \
		gstadaptivedemux_dep:gstadaptivedemux \
		gstisoff_dep:gstisoff \
		gsturidownloader_dep:gsturidownloader
}

pkg_postinst() {
	einfo "media-plugins/gst-plugins-adaptivedemux2 provides an alternative smooth streaming demuxer option (mssdemux2)"
}
