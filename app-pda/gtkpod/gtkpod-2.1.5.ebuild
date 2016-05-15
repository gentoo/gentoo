# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="A graphical user interface to the Apple productline"
HOMEPAGE="http://www.gtkpod.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="aac clutter curl cdr flac gstreamer mp3 vorbis"
REQUIRED_USE="cdr? ( gstreamer )"

COMMON_DEPEND="
	>=dev-libs/gdl-3.6:3
	>=dev-libs/glib-2.31:2
	>=dev-libs/libxml2-2.7.7:2
	>=dev-util/anjuta-3.6
	>=media-libs/libgpod-0.8.2:=
	>=media-libs/libid3tag-0.15
	>=x11-libs/gtk+-3.0.8:3
	aac? ( media-libs/faad2 )
	clutter? ( >=media-libs/clutter-gtk-1.2:1.0 )
	curl? ( >=net-misc/curl-7.10 )
	flac? ( media-libs/flac )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		cdr? (
			>=app-cdr/brasero-3
			>=media-libs/libdiscid-0.2.2
			media-libs/musicbrainz:5
			)
		)
	mp3? ( media-sound/lame )
	vorbis? (
		media-libs/libvorbis
		media-sound/vorbis-tools
		)
"

# to pull in at least -flac and -vorbis plugins , but others at the same time
RDEPEND="${COMMON_DEPEND}
	gstreamer? ( media-plugins/gst-plugins-meta:1.0 )
"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/flex
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1.3-gold.patch
	epatch "${FILESDIR}"/${PN}-2.1.5-m4a.patch

	sed -i -e 's:python:python2:' scripts/sync-palm-jppy.py || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# Prevent sandbox violations, bug #420279
	addpredict /dev

	gnome2_src_configure \
		--enable-deprecations \
		--disable-static \
		--disable-plugin-coverweb \
		$(use_enable clutter plugin-clarity) \
		$(use_enable gstreamer plugin-media-player) \
		$(use_enable cdr plugin-sjcd) \
		$(use_with curl) \
		$(use_with vorbis ogg) \
		$(use_with flac) \
		$(use_with aac mp4)
}

src_install() {
	gnome2_src_install \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF}/html \
		figuresdir=/usr/share/doc/${PF}/html/figures \
		install

	dodoc AUTHORS ChangeLog NEWS README TODO TROUBLESHOOTING
	rm -f "${ED}"/usr/share/gtkpod/data/{AUTHORS,COPYING} || die
}
