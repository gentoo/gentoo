# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/dvds/DVDS}
WX_GTK_VER=3.2-gtk3

inherit wxwidgets

DESCRIPTION="A cross-platform free DVD authoring application"
HOMEPAGE="https://www.dvdstyler.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +udev"

DEPEND="
	app-cdr/cdrtools
	>=app-cdr/dvd+rw-tools-7.1
	media-libs/libexif:=
	>=media-libs/wxsvg-1.5.23:=
	>=media-video/dvdauthor-0.7.1
	>=media-video/ffmpeg-2.6:0=[encode]
	>=media-video/xine-ui-0.99.7
	virtual/jpeg:0
	x11-libs/wxGTK:${WX_GTK_VER}=[gstreamer,X]
	sys-apps/dbus
	udev? ( >=virtual/libudev-215:= )
"
RDEPEND="${DEPEND}
	>=app-cdr/dvdisaster-0.72.4
	media-video/mjpegtools
"
BDEPEND="
	app-arch/zip
	app-text/xmlto
	sys-devel/gettext
	app-alternatives/yacc
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/ffmpeg5.patch
	"${FILESDIR}"/wx30.patch
	"${FILESDIR}"/wx32.patch
)

src_prepare() {
	default

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
	setup-wxwidgets unicode
	econf \
		$(use_enable debug) \
		--with-wx-config="${WX_CONFIG}"
}

src_install() {
	default
	rm "${ED}"/usr/share/doc/${PF}/{COPYING*,INSTALL*} || die
}
