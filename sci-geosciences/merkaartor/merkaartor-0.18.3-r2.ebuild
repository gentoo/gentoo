# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar cs de en es et fr hr hu id_ID it ja nl pl pt_BR pt ru sk sv uk vi zh_CN zh_TW"

inherit gnome2-utils l10n qmake-utils xdg-utils

DESCRIPTION="Qt based map editor for the openstreetmap.org project"
HOMEPAGE="http://www.merkaartor.be https://github.com/openstreetmap/merkaartor"
SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug exif gps libproxy"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtsingleapplication[X,qt5(+)]
	>=sci-libs/gdal-1.6.0
	>=sci-libs/proj-4.6
	sys-libs/zlib
	exif? ( media-gfx/exiv2:= )
	gps? ( >=sci-geosciences/gpsd-3.17-r2 )
	libproxy? ( net-libs/libproxy )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

DOCS=( AUTHORS CHANGELOG )

src_prepare() {
	default

	my_rm_loc() {
		sed -i -e "s:../translations/${PN}_${1}.\(ts\|qm\)::" src/src.pro || die
		rm "translations/${PN}_${1}.ts" || die
	}

	if [[ -n "$(l10n_get_locales)" ]]; then
		l10n_for_each_disabled_locale_do my_rm_loc
		$(qt5_get_bindir)/lrelease src/src.pro || die
	fi

	# build system expects to be building from git
	sed -i "${S}"/src/Config.pri -e "s:SION = .*:SION = \"${PV}\":g" || die
}

src_configure() {
	# TRANSDIR_SYSTEM is for bug #385671
	eqmake5 \
		PREFIX="${ED}usr" \
		LIBDIR="${ED}usr/$(get_libdir)" \
		TRANSDIR_MERKAARTOR="${ED}usr/share/${PN}/translations" \
		TRANSDIR_SYSTEM="${EPREFIX}/usr/share/qt5/translations" \
		SYSTEM_QTSA=1 \
		RELEASE=1 \
		NODEBUG="$(usex debug '0' '1')" \
		GEOIMAGE="$(usex exif '1' '0')" \
		GPSDLIB="$(usex gps '1' '0')" \
		LIBPROXY="$(usex libproxy '1' '0')" \
		ZBAR=0 \
		Merkaartor.pro
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
