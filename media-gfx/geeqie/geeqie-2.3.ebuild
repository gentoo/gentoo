# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua5-{3,4} )

inherit flag-o-matic lua-single meson optfeature xdg

DESCRIPTION="A lightweight GTK image viewer forked from GQview"
HOMEPAGE="http://www.geeqie.org"
SRC_URI="https://github.com/BestImageViewer/${PN}/releases/download/v${PV}/${P}.tar.xz
	https://dev.gentoo.org/~voyageur/distfiles/${P}-docs.tar.xz"
# Doc build:
# clone git at matching tag
# mkdir build; ./gen_changelog.sh . build;
# pandoc README.md -o build/README.html

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86"
IUSE="debug djvu exif ffmpegthumbnailer heif jpeg jpeg2k jpegxl lcms lua map pdf raw spell tiff webp xmp zip"

RDEPEND="gnome-extra/zenity
	virtual/libintl
	x11-libs/gtk+:3
	djvu? ( app-text/djvu )
	exif? ( >=media-gfx/exiv2-0.17:=[xmp?] )
	ffmpegthumbnailer? ( media-video/ffmpegthumbnailer )
	heif? ( >=media-libs/libheif-1.3.2 )
	jpeg2k? ( >=media-libs/openjpeg-2.3.0:2= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpegxl? ( >=media-libs/libjxl-0.3.7:= )
	lcms? ( media-libs/lcms:2 )
	lua? ( ${LUA_DEPS} )
	map? ( media-libs/clutter-gtk
		media-libs/libchamplain:0.12[gtk] )
	pdf? ( >=app-text/poppler-0.62[cairo] )
	raw? ( >=media-libs/libraw-0.20:= )
	spell? ( app-text/gspell )
	tiff? ( media-libs/tiff:= )
	webp? ( gui-libs/gdk-pixbuf-loader-webp:= )
	zip? ( >=app-arch/libarchive-3.4.0 )"
DEPEND="${RDEPEND}"
BDEPEND="
	|| ( dev-util/xxdi app-editors/vim-core )
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

PATCHES=( "${FILESDIR}"/${PN}-2.3-test-ancillary.patch
	"${FILESDIR}"/${P}-locale.patch
	)

pkg_setup() {
	# Do not require setting LUA_SINGLE_TARGET if lua is not used
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default

	# Disable doc build - not useful most of the time per upstream
	sed -e "/subdir('doc')/d" -i meson.build || die
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/585432
	# https://github.com/BestImageViewer/geeqie/issues/1270
	filter-lto

	local emesonargs=(
		-Dgq_helpdir="share/doc/${PF}"
		-Dgq_htmldir="share/doc/${PF}/html"
		$(meson_use debug)
		$(meson_feature djvu)
		$(meson_feature exif exiv2)
		$(meson_feature ffmpegthumbnailer videothumbnailer)
		$(meson_feature heif)
		$(meson_feature jpeg)
		$(meson_feature jpeg2k j2k)
		$(meson_feature jpegxl)
		$(meson_feature lcms cms)
		$(meson_feature lua)
		$(meson_feature map gps-map)
		$(meson_feature pdf)
		$(meson_feature raw libraw)
		$(meson_feature spell)
		$(meson_feature tiff)
		$(meson_feature zip archive)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# Manually generated ChangeLog
	dodoc "${WORKDIR}"/${P}-docs/*

	# The application needs access to some uncompressed doc files.
	docompress -x /usr/share/doc/${PF}/AUTHORS
	docompress -x /usr/share/doc/${PF}/ChangeLog
	docompress -x /usr/share/doc/${PF}/README.md
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "Camera import and tethered photography plugins" media-gfx/gphoto2
	optfeature "Lens ID plugin" media-libs/exiftool
	optfeature "Image crop plugin" "media-libs/exiftool media-gfx/imagemagick"
	optfeature "Image rotate plugin (JPEG)" media-gfx/fbida
	optfeature "Image rotate plugin (TIFF/PNG)" media-gfx/imagemagick
	optfeature "Print preview functionality" app-text/evince
}
