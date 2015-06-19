# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mpeg2dec/gst-plugins-mpeg2dec-1.2.4-r1.ebuild,v 1.11 2014/10/11 13:21:49 maekke Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-ugly
inherit gstreamer

DESCRIPTION="Libmpeg2 based decoder plug-in for gstreamer"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=media-libs/libmpeg2-0.5.1-r2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
