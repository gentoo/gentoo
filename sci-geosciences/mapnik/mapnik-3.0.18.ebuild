# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils scons-utils toolchain-funcs

DESCRIPTION="A Free Toolkit for developing mapping applications"
HOMEPAGE="http://www.mapnik.org/"
SRC_URI="https://github.com/mapnik/mapnik/releases/download/v${PV}/mapnik-v${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/mapnik-v${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo debug doc gdal osmfonts postgres sqlite"

RDEPEND="
	>=dev-libs/boost-1.48:=[threads]
	dev-libs/icu:=
	sys-libs/zlib
	media-libs/freetype
	media-libs/harfbuzz
	dev-libs/libxml2
	media-libs/libpng:0=
	media-libs/tiff:0=
	virtual/jpeg:0=
	media-libs/libwebp:=
	sci-libs/proj
	media-fonts/dejavu
	x11-libs/agg[truetype]
	cairo? (
		x11-libs/cairo
		dev-cpp/cairomm
	)
	osmfonts? (
		media-fonts/dejavu
		media-fonts/noto
		media-fonts/noto-cjk
		media-fonts/unifont
	)
	postgres? ( >=dev-db/postgresql-8.3:* )
	gdal? ( sci-libs/gdal )
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.0-configure-only-once.patch"
	"${FILESDIR}/${PN}-2.2.0-dont-run-ldconfig.patch"
	"${FILESDIR}/${PN}-3.0.18-scons.patch"
	"${FILESDIR}/${PN}-3.0.18-icu-61.patch"
)

src_prepare() {
	default

	# do not version epidoc data
	sed -i \
		-e 's:-`mapnik-config --version`::g' \
		utils/epydoc_config/build_epydoc.sh || die

	# force user flags, optimization level
	sed -i -e "s:\-O%s:%s:" \
		-i -e "s:env\['OPTIMIZATION'\]:'${CXXFLAGS}':" \
		SConstruct || die
}

src_configure() {
#	local PYTHONCMD="$(which python2.7)"
	local PLUGINS=shape,csv,raster,geojson
	use gdal && PLUGINS+=,gdal,ogr
	use postgres && PLUGINS+=,postgis
	use sqlite && PLUGINS+=,sqlite

	MYSCONS=(
		"CC=$(tc-getCC)"
		"CXX=$(tc-getCXX)"
		"INPUT_PLUGINS=${PLUGINS}"
		"PREFIX=/usr"
		"DESTDIR=${D}"
		"XMLPARSER=libxml2"
		"LINKING=shared"
		"RUNTIME_LINK=shared"
		"PROJ_INCLUDES=/usr/include"
		"PROJ_LIBS=/usr/$(get_libdir)"
		"LIBDIR_SCHEMA=$(get_libdir)"
		"FREETYPE_INCLUDES=/usr/include/freetype2"
		"FREETYPE_LIBS=/usr/$(get_libdir)"
		"XML2_INCLUDES=/usr/include/libxml2"
		"XML2_LIBS=/usr/$(get_libdir)"
		"SYSTEM_FONTS=/usr/share/fonts"
		CAIRO="$(usex cairo 1 0)"
		DEBUG="$(usex debug 1 0)"
		XML_DEBUG="$(usex debug 1 0)"
		DEMO="$(usex doc 1 0)"
		SAMPLE_INPUT_PLUGINS="$(usex doc 1 0)"
		"CUSTOM_LDFLAGS=${LDFLAGS}"
		"CUSTOM_LDFLAGS+=-L${ED}/usr/$(get_libdir)"
	)
	escons "${MYSCONS[@]}" configure
}

src_compile() {
	escons "${MYSCONS[@]}"
}

src_install() {
	escons "${MYSCONS[@]}" DESTDIR="${D}" install

	dodoc AUTHORS.md README.md CHANGELOG.md
}

pkg_postinst() {
	elog ""
	elog "See the home page or wiki (https://github.com/mapnik/mapnik/wiki) for more info"
	elog "or the installed examples for the default mapnik ogcserver config."
	elog ""
}
