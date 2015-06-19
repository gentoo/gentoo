# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-flac/gst-plugins-flac-0.10.31-r1.ebuild,v 1.11 2014/10/11 13:11:52 maekke Exp $

EAPI="5"

GST_ORG_MODULE="gst-plugins-good"
inherit gstreamer

DESCRIPTION="GStreamer encoder/decoder/tagger for FLAC"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/flac-1.2.1-r5[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
