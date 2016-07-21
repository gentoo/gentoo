# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer

KEYWORDS="alpha amd64 ~arm ~ia64 ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/libcdio-0.90-r1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
