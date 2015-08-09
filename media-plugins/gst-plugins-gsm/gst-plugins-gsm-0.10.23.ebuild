# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for GSM audio decoding/encoding"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-sound/gsm"
DEPEND="${RDEPEND}"
