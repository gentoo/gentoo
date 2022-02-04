# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
LUA_COMPAT=( lua5-{1..3} )

inherit autotools lua-single xdg

DESCRIPTION="A lightweight GTK image viewer forked from GQview"
HOMEPAGE="http://www.geeqie.org"
SRC_URI="http://www.geeqie.org/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug doc exif ffmpegthumbnailer gpu-accel gtk3 jpeg lcms lirc lua map nls pdf tiff xmp"

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
	lua? ( ${LUA_DEPS} )
	map? ( media-libs/libchamplain:0.12 )
	pdf? ( >=app-text/poppler-0.62[cairo] )
	tiff? ( media-libs/tiff:0 )
	xmp? ( >=media-gfx/exiv2-0.17:=[xmp] )
	!xmp? ( exif? ( >=media-gfx/exiv2-0.17:= ) )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	dev-util/intltool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	gpu-accel? ( gtk3 )
	map? ( gpu-accel )"

PATCHES=( "${FILESDIR}"/${P}-no_common.patch )

src_prepare() {
	default

	# Remove -Werror (gcc changes may add new warnings)
	sed -e '/CFLAGS/s/-Werror //g' -i configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
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
		$(use_enable nls)
		$(use_enable pdf)
		$(use_enable tiff)
	)

	if use exif || use xmp; then
		myeconfargs+=( --enable-exiv2 )
	else
		myeconfargs+=( --disable-exiv2)
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	rm -f "${D}/usr/share/doc/${PF}/COPYING"
	# Application needs access to the uncompressed file
	docompress -x /usr/share/doc/${PF}/README.md
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "Some plugins may require additional packages"
	elog "- Image rotate plugin: media-gfx/fbida (JPEG), media-gfx/imagemagick (TIFF/PNG)"
	elog "- RAW images plugin: media-gfx/ufraw"
}
