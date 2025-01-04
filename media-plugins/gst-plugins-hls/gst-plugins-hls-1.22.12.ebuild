# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="HTTP live streaming plugin for GStreamer"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="dev-libs/nettle:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/gst-plugins-bad-1.18.4-use-system-libs-hls.patch
)

src_prepare() {
	default
	gstreamer_system_library \
		gstadaptivedemux_dep:gstadaptivedemux \
		gsturidownloader_dep:gsturidownloader
}

multilib_src_configure() {
	local emesonargs=(
		-Dhls-crypto=nettle
	)

	gstreamer_multilib_src_configure
}

pkg_postinst() {
	einfo "media-plugins/gst-plugins-adaptivedemux2 provides an alternative HLS demuxer option (hlsdemux2)"
}
