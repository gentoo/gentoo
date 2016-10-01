# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="DTS audio decoder plugin for Gstreamer"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 x86 ~amd64-fbsd"
IUSE="+orc"

RDEPEND="
	>=media-libs/libdca-0.0.5-r3[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
