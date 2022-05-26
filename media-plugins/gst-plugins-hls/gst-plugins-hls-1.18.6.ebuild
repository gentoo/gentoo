# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="HTTP live streaming plugin for GStreamer"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/nettle:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/gst-plugins-bad-1.18.4-use-system-libs-hls.patch
)

src_prepare() {
	default
	gstreamer_system_library gstadaptivedemux_dep:gstadaptivedemux
	gstreamer_system_package pbutils_dep:gstreamer-pbutils
	gstreamer_system_package tag_dep:gstreamer-tag
	gstreamer_system_package video_dep:gstreamer-video
	gstreamer_system_library gsturidownloader_dep:gsturidownloader
}

multilib_src_configure() {
	local emesonargs=(
		-Dhls-crypto=nettle
	)

	gstreamer_multilib_src_configure
}
