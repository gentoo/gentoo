# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=${P/dvds/DVDS}
WX_GTK_VER=2.8

inherit wxwidgets

DESCRIPTION="A cross-platform free DVD authoring application"
HOMEPAGE="http://www.dvdstyler.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +udev"

COMMON_DEPEND=">=app-cdr/dvd+rw-tools-7.1
	media-libs/libexif:=
	>=media-libs/wxsvg-1.2:=
	>=media-video/dvdauthor-0.7.1
	>=media-video/xine-ui-0.99.7
	virtual/cdrtools
	>=virtual/ffmpeg-9-r1[encode]
	virtual/jpeg:0
	>=x11-libs/wxGTK-2.8.7:2.8=[gstreamer,X]
	udev? ( >=virtual/libudev-215:= )"
RDEPEND="${COMMON_DEPEND}
	>=app-cdr/dvdisaster-0.72.4
	media-video/mjpegtools"
DEPEND="${COMMON_DEPEND}
	app-arch/zip
	app-text/xmlto
	sys-devel/gettext
	virtual/yacc
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# disable obsolete GNOME 2.x libraries wrt #508854
	sed -i -e '/PKG_CONFIG/s:libgnomeui-2.0:dIsAbLeAuToMaGiC&:' configure || die
	# rmdir: failed to remove `tempfoobar': Directory not empty
	sed -i -e '/rmdir "$$t"/d' docs/Makefile.in || die
	# fix underlinking wrt #367863
	sed -i -e 's:@LIBS@:& -ljpeg:' wxVillaLib/Makefile.in || die
	# silence desktop-file-validate QA check
	sed -i \
		-e '/Icon/s:.png::' -e '/^Encoding/d' -e '/Categories/s:Application;::' \
		data/dvdstyler.desktop || die
}

src_configure() {
	econf \
	 	--docdir=/usr/share/doc/${PF} \
		$(use_enable debug) \
		--with-wx-config=${WX_CONFIG}
}

src_install() {
	default
	rm -f "${ED}"/usr/share/doc/${PF}/{COPYING*,INSTALL*}
}
