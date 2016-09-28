# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="Opus audio parser plugin for GStreamer"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-1.0.2-r2:=[${MULTILIB_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"
