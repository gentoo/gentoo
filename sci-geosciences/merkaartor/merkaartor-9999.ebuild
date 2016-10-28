# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="ar cs de en es et fr hr hu id_ID it ja nl pl pt_BR pt ru sk sv uk vi zh_CN zh_TW"

inherit fdo-mime gnome2-utils git-r3 l10n qmake-utils

DESCRIPTION="A Qt based map editor for the openstreetmap.org project"
HOMEPAGE="http://www.merkaartor.be https://github.com/openstreetmap/merkaartor"
SRC_URI=""
EGIT_REPO_URI="https://github.com/openstreetmap/merkaartor.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug exif gps libproxy qrcode qt5"

REQUIRED_USE="qrcode? ( !qt5 )"

RDEPEND="
	!qt5? (
		>=dev-libs/quazip-0.7[qt4(+)]
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtsingleapplication[qt4]
		dev-qt/qtsvg:4
		dev-qt/qtwebkit:4
	)
	qt5? (
		>=dev-libs/quazip-0.7.1[qt5]
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsvg:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	dev-qt/qtsingleapplication[X,qt5?]
	>=sci-libs/gdal-1.6.0
	>=sci-libs/proj-4.6
	sys-libs/zlib
	exif? ( media-gfx/exiv2:= )
	gps? ( >=sci-geosciences/gpsd-3.13[cxx] )
	libproxy? ( net-libs/libproxy )
	qrcode? ( media-gfx/zbar[qt4] )
"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools )
	virtual/pkgconfig
"

DOCS=( AUTHORS CHANGELOG )

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	default

	my_rm_loc() {
		sed -i -e "s:../translations/${PN}_${1}.\(ts\|qm\)::" src/src.pro || die
		rm "translations/${PN}_${1}.ts" || die
	}

	if [[ -n "$(l10n_get_locales)" ]]; then
		l10n_for_each_disabled_locale_do my_rm_loc
		if use qt5 ; then
			$(qt5_get_bindir)/lrelease src/src.pro || die
		else
			$(qt4_get_bindir)/lrelease src/src.pro || die
		fi
	fi

	# build system expects to be building from git
	if [[ ${PV} != *9999 ]] ; then
		sed -i "${S}"/src/Config.pri -e "s:SION = .*:SION = \"${PV}\":g" || die
	fi
}

src_configure() {
	# TRANSDIR_SYSTEM is for bug #385671
	if use qt5 ; then
		eqmake5 \
		PREFIX="${ED}usr" \
		LIBDIR="${ED}usr/$(get_libdir)" \
		TRANSDIR_MERKAARTOR="${ED}usr/share/${PN}/translations" \
		TRANSDIR_SYSTEM="${EPREFIX}/usr/share/qt5/translations" \
		SYSTEM_QTSA=1 \
		SYSTEM_QUAZIP=1 \
		NODEBUG="$(usex debug '0' '1')" \
		GEOIMAGE="$(usex exif '1' '0')" \
		GPSDLIB="$(usex gps '1' '0')" \
		LIBPROXY="$(usex libproxy '1' '0')" \
		ZBAR="$(usex qrcode '1' '0')" \
		Merkaartor.pro
	else
		eqmake4 \
		PREFIX="${ED}usr" \
		LIBDIR="${ED}usr/$(get_libdir)" \
		TRANSDIR_MERKAARTOR="${ED}usr/share/${PN}/translations" \
		TRANSDIR_SYSTEM="${EPREFIX}/usr/share/qt4/translations" \
		SYSTEM_QTSA=1 \
		SYSTEM_QUAZIP=1 \
		NODEBUG="$(usex debug '0' '1')" \
		GEOIMAGE="$(usex exif '1' '0')" \
		GPSDLIB="$(usex gps '1' '0')" \
		LIBPROXY="$(usex libproxy '1' '0')" \
		ZBAR="$(usex qrcode '1' '0')" \
		Merkaartor.pro
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
