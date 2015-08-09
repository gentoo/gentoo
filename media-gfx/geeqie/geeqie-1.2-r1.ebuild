# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools base eutils

DESCRIPTION="A lightweight GTK image viewer forked from GQview"
HOMEPAGE="http://www.geeqie.org"
# Grab from tag snapshot: http://www.geeqie.org/cgi-bin/gitweb.cgi?p=geeqie.git
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc exif jpeg lcms lirc lua tiff xmp"

RDEPEND="x11-libs/gtk+:2
	virtual/libintl
	doc? ( app-text/gnome-doc-utils )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	lirc? ( app-misc/lirc )
	lua? ( >=dev-lang/lua-5.1:= )
	xmp? ( >=media-gfx/exiv2-0.17:=[xmp] )
	!xmp? ( exif? ( >=media-gfx/exiv2-0.17 ) )
	tiff? ( media-libs/tiff:0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

S=${WORKDIR}/${PN}-${PN}

PATCHES=(
	"${FILESDIR}"/${P}-fix-lcms2-integration.patch
	"${FILESDIR}"/${P}-fix_version.patch
)

src_prepare() {
	base_src_prepare

	epatch_user

	eautoreconf
}

src_configure() {
	# Force disable experimental stuff
	local myconf="--disable-dependency-tracking
		--with-readmedir=/usr/share/doc/${PF}
		--disable-gtk3
		--disable-clutter
		--disable-gps
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
	rm -f "${D}/usr/share/doc/${MY_P}/COPYING"
}

pkg_postinst() {
	elog "Some plugins may require additional packages"
	elog "- Image rotate plugin: media-gfx/fbida (JPEG), media-gfx/imagemagick (TIFF/PNG)"
	elog "- RAW images plugin: media-gfx/ufraw"
}
