# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-soup/gst-plugins-soup-0.10.31-r1.ebuild,v 1.11 2014/10/11 13:28:09 maekke Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gstreamer

DESCRIPTION="GStreamer plugin for HTTP client sources"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
IUSE=""

# FIXME: automagic dependency on libsoup-gnome
RDEPEND=">=net-libs/libsoup-2.44.2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
