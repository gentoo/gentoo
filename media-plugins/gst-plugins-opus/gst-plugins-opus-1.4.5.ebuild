# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-opus/gst-plugins-opus-1.4.5.ebuild,v 1.7 2015/07/17 15:42:41 ago Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPTION="GStreamer plugin for Opus audio codec support"
KEYWORDS="~alpha amd64 ~arm hppa ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd"
IUSE=""

COMMON_DEPEND=">=media-libs/opus-1.0.2-r2:=[${MULTILIB_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-base:${SLOT}[${MULTILIB_USEDEP},ogg]
"
DEPEND="${COMMON_DEPEND}"
