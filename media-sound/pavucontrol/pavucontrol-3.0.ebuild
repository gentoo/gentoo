# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic

DESCRIPTION="Pulseaudio Volume Control, GTK based mixer for Pulseaudio"
HOMEPAGE="http://freedesktop.org/software/pulseaudio/pavucontrol/"
SRC_URI="http://freedesktop.org/software/pulseaudio/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="nls"

RDEPEND="
	>=dev-cpp/gtkmm-3.0:3.0
	>=dev-libs/libsigc++-2.2:2
	>=media-libs/libcanberra-0.16[gtk3]
	>=media-sound/pulseaudio-3[glib]
	virtual/freedesktop-icon-theme
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"

src_configure() {
	append-cxxflags -std=c++11 #567216
	econf \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html \
		--disable-lynx \
		$(use_enable nls)
}
