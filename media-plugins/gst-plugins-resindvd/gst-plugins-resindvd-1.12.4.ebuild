# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="DVD playback support plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

RDEPEND="
	>=media-libs/libdvdnav-4.2.0-r1[${MULTILIB_USEDEP}]
	>=media-libs/libdvdread-4.2.0-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
