# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPION="DVB device capture plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/os-headers"

src_prepare() {
	default
	gstreamer_system_link \
		gst-libs/gst/mpegts:gstreamer-mpegts
}
