# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GST_ORG_MODULE=gst-plugins-bad
MULTILIB_COMPAT=( abi_x86_64 )

inherit gstreamer

DESCRIPTION="SRTP encoder/decoder plugin for GStreamer"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	net-libs/libsrtp:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
