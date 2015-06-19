# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-dts/gst-plugins-dts-1.4.5.ebuild,v 1.4 2015/03/29 10:51:25 jer Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="GStreamer plugin for MPEG-1/2 video encoding"
KEYWORDS="amd64 hppa ~ppc ~ppc64 x86 ~amd64-fbsd"
IUSE="+orc"

RDEPEND="
	>=media-libs/libdca-0.0.5-r3[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
