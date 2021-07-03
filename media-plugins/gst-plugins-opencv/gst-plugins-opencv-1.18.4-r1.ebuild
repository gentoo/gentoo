# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer-meson

DESCRIPTION="OpenCV elements for GStreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

# >=opencv-4.1.2-r3 to help testing removal of older being fine
RDEPEND="
	>=media-libs/opencv-4.1.2-r3:=[contrib,${MULTILIB_USEDEP}]
	<media-libs/opencv-4.6.0
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/gst-plugins-bad-${PV}-use-system-libs-opencv.patch
)

src_prepare() {
	default
	gstreamer_system_package video_dep:gstreamer-video
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}
