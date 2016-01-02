# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gstreamer

DESCRIPTION="GStreamer plugin for the PulseAudio sound server"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="
	>=media-libs/gst-plugins-good-0.10:${SLOT}[${MULTILIB_USEDEP}]
	>=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
