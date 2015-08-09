# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils gnome2-utils

DESCRIPTION="A graphical user interface to the Apple productline"
HOMEPAGE="http://gtkpod.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	http://dev.gentoo.org/~ssuominen/gst-element-check-0.10.m4.xz"

LICENSE="GPL-2 FDL-1.2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="aac clutter curl cdr flac gstreamer mp3 vorbis webkit"

# watch out for possible musicbrainz:5 compability in next version?
COMMON_DEPEND="
	>=dev-libs/gdl-3.6:3
	>=dev-libs/glib-2.31
	>=dev-libs/libxml2-2.7.7
	>=dev-util/anjuta-3.6
	>=media-libs/libgpod-0.8.2:=
	>=media-libs/libid3tag-0.15
	>=x11-libs/gtk+-3.0.8:3
	aac? ( media-libs/faad2 )
	clutter? ( >=media-libs/clutter-gtk-1.2:1.0 )
	curl? ( >=net-misc/curl-7.10 )
	flac? ( media-libs/flac )
	gstreamer? (
		>=media-libs/gstreamer-0.10.25:0.10
		>=media-libs/gst-plugins-base-0.10.25:0.10
		cdr? (
			>=app-cdr/brasero-3
			media-libs/musicbrainz:3
			)
		)
	mp3? ( media-sound/lame )
	vorbis? (
		media-libs/libvorbis
		media-sound/vorbis-tools
		)
	webkit? ( >=net-libs/webkit-gtk-1.3:3 )"
# to pull in at least -flac and -vorbis plugins , but others at the same time
RDEPEND="${COMMON_DEPEND}
	gstreamer? ( media-plugins/gst-plugins-meta:0.10 )"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool
	sys-devel/flex
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig"
REQUIRED_USE="cdr? ( gstreamer )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1.3-gold.patch

	sed -i -e 's:python:python2:' scripts/sync-palm-jppy.py || die
	# punt deprecated flags for forward compability
	# use more widely used musicbrainz:3 instead of :4
	# use AC_CONFIG_HEADERS for automake-1.13 compability wrt #467598
	sed -e 's:CLEANLINESS_FLAGS=".*:CLEANLINESS_FLAGS="":' \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e '/PKG_CHECK_MODULES/s:libmusicbrainz4:&sLoT4iSdEpReCaTeD:' \
		-i configure.ac || die
	# /path/to/install: '/path/to/app-pda/gtkpod-2.1.2_beta2/image/usr/share/gtkpod/data/rhythmbox.gep’: File exists
	sed -i -e '/^dist_profiles_DATA/s:=.*:=:' plugins/sjcd/data/Makefile.am || die

	# m4dir for gst-element-check-0.10.m4
	AT_M4DIR=${WORKDIR} eautoreconf
}

src_configure() {
	export GST_INSPECT=true #420279

	econf \
		--disable-static \
		$(use_enable webkit plugin-coverweb) \
		$(use_enable clutter plugin-clarity) \
		$(use_enable gstreamer plugin-media-player) \
		$(use_enable cdr plugin-sjcd) \
		$(use_with curl) \
		$(use_with vorbis ogg) \
		$(use_with flac) \
		$(use_with aac mp4)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF}/html \
		figuresdir=/usr/share/doc/${PF}/html/figures \
		install

	prune_libtool_files --all

	dodoc AUTHORS ChangeLog NEWS README TODO TROUBLESHOOTING
	rm -f "${ED}"/usr/share/gtkpod/data/{AUTHORS,COPYING} || die
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
