# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

KEYWORDS="alpha amd64 ~ppc ppc64 x86"
IUSE=""

RDEPEND=">=net-libs/neon-0.30.0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
