# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Gnonlin is a set of GStreamer elements to ease the creation of non-linear multimedia editors"
HOMEPAGE="http://gnonlin.sourceforge.net"
SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0.10"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/gstreamer-0.10.9:0.10
	 >=media-libs/gst-plugins-base-0.10.9:0.10"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README RELEASE
}
