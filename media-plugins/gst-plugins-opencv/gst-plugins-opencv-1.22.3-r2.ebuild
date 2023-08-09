# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad
PYTHON_COMPAT=( python3_{10..11} )
inherit gstreamer-meson python-any-r1

DESCRIPTION="OpenCV elements for GStreamer"
KEYWORDS="~amd64 ~x86"

# >=opencv-4.1.2-r3 to help testing removal of older being fine
RDEPEND="
	>=media-libs/opencv-4.1.2-r3:=[contrib,contribdnn,${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/gst-plugins-bad-1.22.3-use-system-libs-opencv.patch
)

src_prepare() {
	default
	gstreamer_system_package video_dep:gstreamer-video
}

multilib_src_configure() {
	local emesonargs=(
		# We need to disable here to avoid colliding w/ gst-plugins-bad
		# on translations, because we currently do a "full" install in
		# multilib_src_install in this package. See bug #907480.
		-Dnls=disabled
	)

	gstreamer_multilib_src_configure
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
}
