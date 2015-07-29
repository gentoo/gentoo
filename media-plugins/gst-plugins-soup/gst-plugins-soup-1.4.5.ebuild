# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-soup/gst-plugins-soup-1.4.5.ebuild,v 1.10 2015/07/29 10:54:54 klausman Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit gstreamer

DESCRIPTION="GStreamer plugin for HTTP client source/sink"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
IUSE=""

# Depend on >=net-libs/libsoup-2.47.0 once it is stable (see LIBSOUP_DOES_NOT_STEAL_OUR_CONTEXT in ext/soup)
RDEPEND=">=net-libs/libsoup-2.44.2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
