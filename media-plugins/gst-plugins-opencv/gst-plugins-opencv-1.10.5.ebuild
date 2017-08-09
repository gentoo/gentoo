# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="OpenCV elements for Gstreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/opencv-2.3.0[contrib(+),${MULTILIB_USEDEP}]
	<media-libs/opencv-3.1.1
"
DEPEND="${RDEPEND}"
