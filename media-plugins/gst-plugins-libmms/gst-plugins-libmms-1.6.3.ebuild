# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~ppc ppc64 ~sparc x86 ~amd64-fbsd"
IUSE=""

RDEPEND=">=media-libs/libmms-0.6.2-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
