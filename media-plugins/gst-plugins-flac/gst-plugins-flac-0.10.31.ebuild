# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gst-plugins-good

DESCRIPTION="GStreamer encoder/decoder/tagger for FLAC"
KEYWORDS="sh"
IUSE=""

RDEPEND=">=media-libs/flac-1.1.4"
DEPEND="${RDEPEND}"
