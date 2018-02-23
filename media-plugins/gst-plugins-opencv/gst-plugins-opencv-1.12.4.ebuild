# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="OpenCV elements for Gstreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/opencv-2.3.0[contrib(+),${MULTILIB_USEDEP}]
	<media-libs/opencv-3.3.1
"
DEPEND="${RDEPEND}"

# Ships the opencv separate helper library as part of gst-plugins-opencv as it depends on OpenCV
multilib_src_compile() {
	emake -C gst-libs/gst/opencv
	gstreamer_multilib_src_compile
}

multilib_src_install() {
	emake -C gst-libs/gst/opencv DESTDIR="${D}" install
	gstreamer_multilib_src_install
}
