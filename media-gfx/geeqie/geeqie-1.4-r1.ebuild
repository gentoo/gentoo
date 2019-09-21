# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools xdg-utils

DESCRIPTION="A lightweight GTK image viewer forked from GQview"
HOMEPAGE="http://www.geeqie.org"
SRC_URI="http://www.geeqie.org/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug doc exif ffmpegthumbnailer gpu-accel gtk3 jpeg lcms lirc lua map tiff xmp"

RDEPEND="
	virtual/libintl
	doc? ( app-text/gnome-doc-utils )
	ffmpegthumbnailer? ( media-video/ffmpegthumbnailer )
	gpu-accel? ( media-libs/clutter-gtk )
	gtk3? ( x11-libs/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	lirc? ( app-misc/lirc )
	lua? ( >=dev-lang/lua-5.1:= )
	map? ( media-libs/libchamplain:0.12 )
	tiff? ( media-libs/tiff:0 )
	xmp? ( >=media-gfx/exiv2-0.17:=[xmp] )
	!xmp? ( exif? ( >=media-gfx/exiv2-0.17:= ) )"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="gpu-accel? ( gtk3 )
	map? ( gpu-accel )"

PATCHES=( "${FILESDIR}/${P}-exiv2-0.27.patch" ) # bug 674044

src_prepare() {
	default

	# Missing from release tarball, and requires git tree to generate
	sed -e "/readme_DATA/s/ChangeLog\(.html\)\?//g" -i Makefile.am || die

	# Remove -Werror (gcc changes may add new warnings)
	sed -e '/CFLAGS/s/-Werror //g' -i configure.in || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	local myconf="--disable-dependency-tracking
		--with-readmedir="${EPREFIX}"/usr/share/doc/${PF}
		$(use_enable debug debug-log)
		$(use_enable ffmpegthumbnailer)
		$(use_enable gpu-accel)
		$(use_enable gtk3)
		$(use_enable jpeg)
		$(use_enable lcms)
		$(use_enable lua)
		$(use_enable lirc)
		$(use_enable map)
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
	docompress -x /usr/share/doc/${PF}/README.md
}

pkg_postinst() {
	xdg_desktop_database_update

	elog "Some plugins may require additional packages"
	elog "- Image rotate plugin: media-gfx/fbida (JPEG), media-gfx/imagemagick (TIFF/PNG)"
	elog "- RAW images plugin: media-gfx/ufraw"
}

pkg_postrm() {
	xdg_desktop_database_update
}
