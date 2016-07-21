# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools

DESCRIPTION="A lightweight GTK image viewer forked from GQview"
HOMEPAGE="http://www.geeqie.org"
SRC_URI="http://www.geeqie.org/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug doc exif gtk3 jpeg lcms lirc lua tiff xmp"

RDEPEND="gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	virtual/libintl
	doc? ( app-text/gnome-doc-utils )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	lirc? ( app-misc/lirc )
	lua? ( >=dev-lang/lua-5.1:= )
	xmp? ( >=media-gfx/exiv2-0.17:=[xmp] )
	!xmp? ( exif? ( >=media-gfx/exiv2-0.17:= ) )
	tiff? ( media-libs/tiff:0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-fix_keywords_gtk3.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# clutter does not compile, gps depends on clutter
	local myconf="--disable-dependency-tracking
		--with-readmedir=/usr/share/doc/${PF}
		--disable-clutter
		--disable-gps
		$(use_enable debug debug-log)
		$(use_enable gtk3)
		$(use_enable jpeg)
		$(use_enable lcms)
		$(use_enable lua)
		$(use_enable lirc)
		$(use_enable tiff)"

	if use exif || use xmp; then
		myconf="${myconf} --enable-exiv2"
	else
		myconf="${myconf} --disable-exiv2"
	fi

	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" install

	rm -f "${D}/usr/share/doc/${PF}/COPYING"
	# Application needs access to the uncompressed file
	docompress -x /usr/share/doc/${PF}/README
}

pkg_postinst() {
	elog "Some plugins may require additional packages"
	elog "- Image rotate plugin: media-gfx/fbida (JPEG), media-gfx/imagemagick (TIFF/PNG)"
	elog "- RAW images plugin: media-gfx/ufraw"
}
