# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="cs de en es fi fr hr hu id_ID it ja nl pl pt_BR ru sv uk zh_TW"
inherit flag-o-matic plocale qmake-utils xdg

DESCRIPTION="Qt based map editor for the openstreetmap.org project"
HOMEPAGE="http://www.merkaartor.be https://github.com/openstreetmap/merkaartor"
SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug exif gps libproxy webengine"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[X,qt5(+)]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sci-libs/gdal:=
	<sci-libs/proj-8:=
	sys-libs/zlib
	exif? ( media-gfx/exiv2:= )
	gps? ( >=sci-geosciences/gpsd-3.17-r2 )
	libproxy? ( net-libs/libproxy )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.18.3-sharedir-pluginsdir.patch # bug 621826
)

DOCS=( AUTHORS CHANGELOG )

src_prepare() {
	default

	rm -r 3rdparty || die "Failed to remove bundled libs"

	my_rm_loc() {
		sed -i -e "s:../translations/${PN}_${1}.\(ts\|qm\)::" src/src.pro || die
		rm "translations/${PN}_${1}.ts" || die
	}

	if [[ -n "$(plocale_get_locales)" ]]; then
		plocale_for_each_disabled_locale my_rm_loc
		$(qt5_get_bindir)/lrelease src/src.pro || die
	fi

	# build system expects to be building from git
	sed -i src/Config.pri -e "s:SION = .*:SION = \"${PV}\":g" || die
}

src_configure() {
	append-cppflags -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H

	# TRANSDIR_SYSTEM is for bug #385671
	eqmake5 \
		PREFIX="${ED}/usr" \
		LIBDIR="${ED}/usr/$(get_libdir)" \
		PLUGINS_DIR="/usr/$(get_libdir)/${PN}/plugins" \
		SHARE_DIR_PATH="/usr/share/${PN}" \
		TRANSDIR_MERKAARTOR="${ED}/usr/share/${PN}/translations" \
		TRANSDIR_SYSTEM="${EPREFIX}/usr/share/qt5/translations" \
		SYSTEM_QTSA=1 \
		RELEASE=1 \
		NODEBUG=$(usex debug 0 1) \
		GEOIMAGE=$(usex exif 1 0) \
		GPSDLIB=$(usex gps 1 0) \
		LIBPROXY=$(usex libproxy 1 0) \
		USEWEBENGINE=$(usex webengine 1 0) \
		Merkaartor.pro
}
