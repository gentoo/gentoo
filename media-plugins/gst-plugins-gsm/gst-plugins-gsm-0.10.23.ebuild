# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-gsm/gst-plugins-gsm-0.10.23.ebuild,v 1.5 2013/02/26 12:40:31 eva Exp $

EAPI="5"

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for GSM audio decoding/encoding"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-sound/gsm"
DEPEND="${RDEPEND}"
