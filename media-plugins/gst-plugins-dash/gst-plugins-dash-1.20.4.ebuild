# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="MPEG-DASH plugin for GStreamer"
KEYWORDS="amd64 x86"

RDEPEND=">=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	gstreamer_system_library gstadaptivedemux_dep:gstadaptivedemux
	gstreamer_system_library gstisoff_dep:gstisoff
	gstreamer_system_package pbutils_dep:gstreamer-pbutils
	gstreamer_system_package tag_dep:gstreamer-tag
	gstreamer_system_library gsturidownloader_dep:gsturidownloader
}
