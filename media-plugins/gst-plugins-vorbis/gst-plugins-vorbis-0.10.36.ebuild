# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-vorbis/gst-plugins-vorbis-0.10.36.ebuild,v 1.13 2013/02/24 18:01:29 ago Exp $

EAPI="5"

inherit gst-plugins-base gst-plugins10 libtool

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-macos"
IUSE=""

RDEPEND=">=media-libs/libvorbis-1
	>=media-libs/libogg-1"
DEPEND="${RDEPEND}"

src_prepare() {
	gst-plugins10_system_link \
		gst-libs/gst/tag:gstreamer-tag \
		gst-libs/gst/audio:gstreamer-audio

	elibtoolize  # for Darwin bundles
}
