# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/corebird/corebird-1.0.ebuild,v 1.1 2015/06/26 18:23:03 pacho Exp $

EAPI=5
VALA_MIN_API_VERSION=0.24
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit eutils autotools-utils gnome2 vala

DESCRIPTION="Native GTK+3 Twitter client"
HOMEPAGE="http://corebird.baedert.org/"
SRC_URI="https://github.com/baedert/corebird/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug gstreamer"

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/glib-2.40:2
	dev-libs/json-glib
	dev-libs/libgee:0.8
	gstreamer? ( media-plugins/gst-plugins-meta:1.0[X,ffmpeg] )
	>=net-libs/libsoup-2.42.3.1
	>=net-libs/rest-0.7.91:0.7
	>=x11-libs/gtk+-3.14:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.40
	sys-apps/sed
	virtual/pkgconfig
"

src_prepare() {
	sed -i -e "/manpagedir/s/manpagedir.*/&\/man1/g" data/Makefile.am || die
	autotools-utils_src_prepare
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(usex gstreamer "" --disable-video)
	)
	gnome2_src_configure "${myeconfargs[@]}"
}
