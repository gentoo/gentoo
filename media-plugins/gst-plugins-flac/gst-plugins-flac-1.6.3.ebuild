# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE="gst-plugins-good"

inherit gstreamer

DESCRIPTION="GStreamer encoder/decoder/tagger for FLAC"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
