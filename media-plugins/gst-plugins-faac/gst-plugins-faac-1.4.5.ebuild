# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-faac/gst-plugins-faac-1.4.5.ebuild,v 1.5 2015/03/15 13:37:04 pacho Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=media-libs/faac-1.28-r3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
