# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic xfconf

DESCRIPTION="A lightweight music player (with support for the Xfce desktop environment)"
HOMEPAGE="http://pragha.wikispaces.com/ http://github.com/matiasdelellis/pragha"
SRC_URI="http://dissonance.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug +glyr lastfm +playlist"

COMMON_DEPEND="dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.100
	>=dev-libs/glib-2.28
	>=dev-libs/keybinder-0.2.2:0
	dev-libs/libcdio-paranoia
	media-libs/gst-plugins-base:0.10
	>=media-libs/libcddb-1.3.2
	>=media-libs/taglib-1.7.1
	>=x11-libs/gtk+-2.24:2
	x11-libs/libX11
	>=x11-libs/libnotify-0.7
	>=xfce-base/libxfce4ui-4.10
	playlist? ( >=dev-libs/totem-pl-parser-2.26 )
	glyr? ( >=media-libs/glyr-1.0.1 )
	lastfm? ( >=media-libs/libclastfm-0.5 )"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-meta:0.10"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable debug)
		$(use_enable lastfm libclastfm)
		$(use_enable glyr libglyr)
		$(use_enable playlist totem-plparser)
		)
}

src_prepare() {
	sed -i -e '/CFLAGS/s:-g -ggdb -O0::' configure || die
	xfconf_src_prepare
}

src_configure() {
	# src/cdda.h should #include config.h to get this defined:
	# http://github.com/matiasdelellis/pragha/issues/46
	append-cppflags -DHAVE_PARANOIA_NEW_INCLUDES
	xfconf_src_configure
}
