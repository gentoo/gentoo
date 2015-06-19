# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gnaural/gnaural-1.0.20110606.ebuild,v 1.4 2014/11/22 16:43:48 pacho Exp $

EAPI=5
GCONF_DEBUG="no"

inherit autotools gnome2

DESCRIPTION="An opensource binaural-beat generator"
HOMEPAGE="http://gnaural.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/Gnaural/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND="
	>=x11-libs/gtk+-2:2
	>=gnome-base/libglade-2
	>=dev-libs/glib-2:2
	>=media-libs/libsndfile-1.0.2
	>=media-libs/portaudio-19_pre20071207
"
DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )
	virtual/pkgconfig
"

src_prepare() {
	mv configure.in configure.ac || die #426262

	# Install desktop file into xdg compliant location
	sed -i -e 's@/gnome/apps/Multimedia@/applications@g' \
		Makefile.am || die "Failed to sed Makefile.am"

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable nls)
}
