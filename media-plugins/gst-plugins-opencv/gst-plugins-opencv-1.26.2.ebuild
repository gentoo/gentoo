# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer-meson

DESCRIPTION="OpenCV elements for GStreamer"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND=">=media-libs/opencv-4.1.2-r3:=[contrib,contribdnn,${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/gst-plugins-bad-1.26.2-use-system-libs-opencv.patch
)

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
