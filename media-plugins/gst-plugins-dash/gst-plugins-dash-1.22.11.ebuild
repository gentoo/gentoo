# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="MPEG-DASH plugin for GStreamer"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND=">=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	gstreamer_system_library \
		gstadaptivedemux_dep:gstadaptivedemux \
		gsturidownloader_dep:gsturidownloader \
		gstisoff_dep:gstisoff
}

pkg_postinst() {
	einfo "media-plugins/gst-plugins-adaptivedemux2 provides an alternative DASH demuxer option (dashdemux2)"
}
