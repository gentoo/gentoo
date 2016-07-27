# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
GCONF_DEBUG=no
inherit eutils gnome2

DESCRIPTION="GnomeBaker is a GTK2/Gnome cd burning application"
HOMEPAGE="https://sourceforge.net/projects/gnomebaker"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE="dvdr flac libnotify mp3 vorbis"

COMMON_DEPEND="app-cdr/cdrdao
	dev-libs/libxml2
	>=gnome-base/libglade-2
	>=gnome-base/libgnomeui-2
	>=media-libs/gstreamer-0.10:0.10
	virtual/cdrtools
	x11-libs/cairo
	x11-libs/gtk+:2
	dvdr? ( app-cdr/dvd+rw-tools )
	libnotify? ( x11-libs/libnotify )"
RDEPEND="${COMMON_DEPEND}
	>=media-libs/gst-plugins-good-0.10:0.10
	flac? ( >=media-plugins/gst-plugins-flac-0.10:0.10 )
	mp3? ( >=media-plugins/gst-plugins-mad-0.10:0.10 )
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.10:0.10 )"
DEPEND="${COMMON_DEPEND}
	app-text/rarian
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	G2CONF="$(use_enable libnotify)"

	epatch \
		"${FILESDIR}"/${P}-libnotify-0.7.patch \
		"${FILESDIR}"/${P}-ldadd.patch \
		"${FILESDIR}"/${P}-seldata.patch \
		"${FILESDIR}"/${P}-mimetype.patch \
		"${FILESDIR}"/${P}-implicits.patch

	gnome2_src_prepare
}

src_install() {
	gnome2_src_install \
		gnomebakerdocdir=/usr/share/doc/${P} \
		docdir=/usr/share/gnome/help/${PN}/C \
		gnomemenudir=/usr/share/applications

	rm -rf "${ED}"/usr/share/doc/${P}/*.make "${ED}"/var
}
