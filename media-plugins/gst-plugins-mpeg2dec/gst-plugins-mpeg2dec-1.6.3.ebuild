# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GST_ORG_MODULE=gst-plugins-ugly

inherit gstreamer

DESCRIPTION="Libmpeg2 based decoder plug-in for gstreamer"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/libmpeg2-0.5.1-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
