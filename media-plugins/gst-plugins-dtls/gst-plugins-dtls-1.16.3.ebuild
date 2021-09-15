# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="DTLS encoder/decoder with SRTP support plugin for GStreamer"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-libs/openssl-1.0.1:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
