# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GST_ORG_MODULE=gst-plugins-good
inherit autotools eutils gstreamer

DESCRIPTION="GStreamer plugin for HTTP client sources"

KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ~ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
IUSE=""

RDEPEND=">=net-libs/libsoup-2.44.2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

src_prepare() {
	# Drop automagic support of libsoup-gnome
	epatch "${FILESDIR}"/${P}-libsoup-gnome.patch
	eautoreconf
}
