# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-flac/gst-plugins-flac-0.10.31.ebuild,v 1.13 2015/01/02 03:17:17 leio Exp $

EAPI="5"

inherit gst-plugins-good

DESCRIPTION="GStreamer encoder/decoder/tagger for FLAC"
KEYWORDS="sh"
IUSE=""

RDEPEND=">=media-libs/flac-1.1.4"
DEPEND="${RDEPEND}"
