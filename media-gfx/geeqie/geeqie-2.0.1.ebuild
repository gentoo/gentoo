# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=( lua5-{3,4} )

inherit lua-single meson xdg

DESCRIPTION="A lightweight GTK image viewer forked from GQview"
HOMEPAGE="http://www.geeqie.org"
SRC_URI="https://github.com/BestImageViewer/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc djvu exif ffmpegthumbnailer gpu-accel heif jpeg jpeg2k jpegxl lcms lua map pdf raw spell tiff webp xmp zip"

RDEPEND="
	virtual/libintl
	x11-libs/gtk+:3
	gnome-extra/zenity
	doc? ( app-text/yelp-tools )
	djvu? ( app-text/djvu )
	ffmpegthumbnailer? ( media-video/ffmpegthumbnailer )
	gpu-accel? ( media-libs/clutter-gtk )
	heif? ( >=media-libs/libheif-1.3.2 )
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( >=media-libs/openjpeg-2.3.0:2 )
	jpegxl? ( >=media-libs/libjxl-0.3.7 )
	lcms? ( media-libs/lcms:2 )
	lua? ( ${LUA_DEPS} )
	map? ( media-libs/libchamplain:0.12 )
	pdf? ( >=app-text/poppler-0.62[cairo] )
	raw? ( >=media-libs/libraw-0.20 )
	spell? ( app-text/gspell )
	tiff? ( media-libs/tiff:0 )
	webp? ( >=media-libs/libwebp-0.6.1 )
	xmp? ( >=media-gfx/exiv2-0.17:=[xmp] )
	!xmp? ( exif? ( >=media-gfx/exiv2-0.17:= ) )
	zip? ( >=app-arch/libarchive-3.4.0 )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	dev-util/intltool
	dev-util/xxdi
	virtual/pkgconfig
	sys-devel/gettext"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	map? ( gpu-accel )"

PATCHES=(
	"${FILESDIR}/${P}-fix-xxdi.patch"
	"${FILESDIR}/${P}-fix-gq_bindir.patch"
	"${FILESDIR}/${P}-disable-lua-api.patch"
	"${FILESDIR}/${P}-disable-pandoc-and-print-preview.patch"
)

# ChangeLog may be NEWS (see src_prepare)
DOCS=( AUTHORS ChangeLog README.md TODO )

src_prepare() {
	default

	# Do not prepare the .html documentation, unless it's required.
	! use doc && \
		eapply "${FILESDIR}/${P}-disable-html-docs.patch"

	# Originally, ChangeLog is created from a merge of ChangeLog.gqview
	# and the (possibly missing) .git log, use NEWS instead.
	cp NEWS ChangeLog || die "Cannot prepare the ChangeLog file"

	# Force the dependency check of lua, in case the installed version
	# isn't already in the the meson.build file.
	local LUA_VERSION="$(lua_get_version)"

	LUA_VERSION="${LUA_VERSION%.*}"

	sed -r -i "s#(lua)5\.[0-9]#\1${LUA_VERSION}#" meson.build || die "Cannot set lua's version to ${LUA_VERSION}"
}

src_configure() {
	local emesonargs=(
		-Dgq_helpdir="share/doc/${PF}"
		-Dgq_htmldir="share/doc/${PF}/html"
		$(meson_use debug)
		$(meson_feature zip archive)
		$(meson_feature lcms cms)
		$(meson_feature djvu)
		$(meson_feature exif exiv2)
		$(meson_feature ffmpegthumbnailer videothumbnailer)
		$(meson_feature gpu-accel gps-map)
		$(meson_feature heif)
		$(meson_feature jpeg2k j2k)
		$(meson_feature jpeg)
		$(meson_feature jpegxl)
		$(meson_feature raw libraw)
		$(meson_feature lua)
		$(meson_feature pdf)
		$(meson_feature spell)
		$(meson_feature tiff)
		$(meson_feature webp)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	# See src/window.c (to verify if it's working, enable the debug use
	# flag, run `geeqie --debug=1`, and try 'Help > Help manual' option
	# to see if in the console 'geeqie_html_browser' is called).
	dobin "${FILESDIR}/geeqie_html_browser"

	# The application needs access to some uncompressed doc files.
	docompress -x /usr/share/doc/${PF}/AUTHORS
	docompress -x /usr/share/doc/${PF}/ChangeLog
	docompress -x /usr/share/doc/${PF}/README.md
}

pkg_postinst() {
	xdg_pkg_postinst

	local plugins_dependencies="at least one plugin dependency is missing"

	# plugins dependencies
	local exiv2="media-gfx/exiv2"
	local fbida="media-gfx/fbida"
	local gphoto2="media-gfx/gphoto2"
	local imagemagick="media-gfx/imagemagick"
	local exiftool="media-libs/exiftool"

	# clear installed plugins dependencies
	has_version "${exiv2}" && exiv2=""
	has_version "${fbida}" && fbida=""
	has_version "${gphoto2}" && gphoto2=""
	has_version "${imagemagick}" && imagemagick=""
	has_version "${exiftool}" && exiftool=""

	# check if there's at least one plugin dependency missing
	[ -n "${exiv2}${fbida}${gphoto2}${imagemagick}${exiftool}" ] || plugins_dependencies=""

	elog "To configure the default browser, export the variable BROWSER,"
	elog "i.e. \`export BROWSER=firefox\`.  The helper geeqie_html_browser"
	elog "will use the environment BROWSER as default browser."

	if ! has_version "app-text/evince"
	then
		elog "" # empty line

		elog "Please install app-text/evince for print preview functionality."
		elog "Alternatively, check \"gtk-print-preview-command\" documentation and"
		elog "add it to your settings.ini file."

		[ -n "${plugins_dependencies}" ] && elog "" # empty line
	fi

	if [ -n "${plugins_dependencies}" ]
	then
		elog "Some plugins may require additional packages:"

		if [ -n "${gphoto2}" ]
		then
			elog "- Camera import plugin: ${gphoto2}"
			elog "- Tethered photography plugin: ${gphoto2}"
		fi

		[ -n "${exiftool}" ] && \
			elog "- Lens ID plugin: ${exiftool}"

		[ -n "${exiv2}" ] && \
			elog "- Export jpeg plugin: ${exiv2}"

		[ -n "${exiv2}${exiftool}${imagemagick}" ] && \
			elog "- Image crop plugin:${exiv2:+ $exiv2}${exiftool:+ $exiftool}${imagemagick:+ $imagemagick}"

		[ -n "${exiv2}${fbida}${imagemagick}" ] && \
			elog "- Image rotate plugin:${exiv2:+ $exiv2}${fbida:+ $fbida (JPEG)}${imagemagick:+ $imagemagick (TIFF/PNG)}"
	fi
}
