# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="DTLS plugin for GStreamer."
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/openssl-1.0.1:0[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
