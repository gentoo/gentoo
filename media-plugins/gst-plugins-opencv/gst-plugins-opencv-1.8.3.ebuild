# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-bad
MULTILIB_COMPAT=( abi_x86_64 )

inherit gstreamer

DESCRIPTION="OpenCV elements for Gstreamer"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=media-libs/opencv-2.3.0[${MULTILIB_USEDEP}]
	<media-libs/opencv-2.5.0[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
