# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils versionator autotools multilib

DESCRIPTION="a GTK+ based utility to split mp3 and ogg files without decoding"
HOMEPAGE="http://mp3splt.sourceforge.net"
SRC_URI="mirror://sourceforge/mp3splt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="audacious doc gtk3 gnome gstreamer nls"

RDEPEND="~media-libs/libmp3splt-0.9.1a
	gtk3? ( x11-libs/gtk+:3
		audacious? ( >=media-sound/audacious-3.0 ) )
	!gtk3? ( >=x11-libs/gtk+-2.18:2
		audacious? ( <media-sound/audacious-3.0 ) )
	!audacious? ( dev-libs/dbus-glib )
	gstreamer? ( media-libs/gstreamer:1.0
		media-plugins/gst-plugins-meta:1.0[mp3] )
	gnome? ( gnome-base/libgnomeui )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	gnome? ( app-text/gnome-doc-utils app-text/rarian )
	nls? ( sys-devel/gettext )"

src_prepare() {
	if use audacious; then
		sed -i \
			-e 's:@AUDACIOUS_LIBS@:-laudclient &:' \
			src/Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local myconf

	use nls || myconf+=" --disable-nls"
	use audacious || myconf+=" --disable-audacious"
	use gstreamer || myconf+=" --disable-gstreamer"

	econf \
		--disable-dependency-tracking \
		$(use_enable gnome) \
		$(use_enable doc doxygen_doc) \
		$(use_enable gtk3) \
		--disable-cutter \
		${myconf}
}

src_install() {
	default
	dodoc AUTHORS ChangeLog NEWS README
}
