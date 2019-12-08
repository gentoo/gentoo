# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator autotools

DESCRIPTION="a GTK+ based utility to split mp3 and ogg files without decoding"
HOMEPAGE="http://mp3splt.sourceforge.net"
SRC_URI="mirror://sourceforge/mp3splt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 sparc x86"
IUSE="doc gstreamer nls"

RDEPEND="
	>=media-libs/libmp3splt-0.9.2
	x11-libs/gtk+:3
	dev-libs/dbus-glib
	gstreamer? (
		media-libs/gstreamer:1.0
		media-plugins/gst-plugins-meta:1.0[mp3] )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf

	use nls || myconf+=" --disable-nls"
	use gstreamer || myconf+=" --disable-gstreamer"

	econf \
		--disable-audacious \
		--disable-gnome \
		$(use_enable doc doxygen_doc) \
		--disable-cutter \
		${myconf}
}
