# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-base

inherit gstreamer

DESCRIPTION="Visualization elements for GStreamer"
KEYWORDS="~alpha amd64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND="
	>=media-libs/libvisual-0.4.0-r3[${MULTILIB_USEDEP}]
	>=media-plugins/libvisual-plugins-0.4.0-r3[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	gstreamer_system_link \
		gst-libs/gst/audio:gstreamer-audio \
		gst-libs/gst/video:gstreamer-video \
		gst-libs/gst/pbutils:gstreamer-pbutils
}
