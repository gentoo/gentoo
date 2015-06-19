# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/merkaartor/merkaartor-9999.ebuild,v 1.17 2015/04/01 06:17:33 jlec Exp $

EAPI=5

PLOCALES="ar cs de es et fr hr hu it ja nl pl pt_BR pt ru sk sv uk"

inherit eutils fdo-mime gnome2-utils git-r3 l10n multilib qt4-r2

DESCRIPTION="A Qt4 based map editor for the openstreetmap.org project"
HOMEPAGE="http://www.merkaartor.be https://github.com/openstreetmap/merkaartor"
SRC_URI=""
EGIT_REPO_URI="https://github.com/openstreetmap/merkaartor.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug exif gps libproxy qrcode"

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtwebkit:4
	>=dev-qt/qtsingleapplication-2.6.1[X,qt4(+)]
	>=dev-libs/quazip-0.7[qt4(+)]
	>=sci-libs/gdal-1.6.0
	>=sci-libs/proj-4.6
	sys-libs/zlib
	exif? ( media-gfx/exiv2:= )
	gps? ( >=sci-geosciences/gpsd-2.92[cxx] )
	libproxy? ( net-libs/libproxy )
	qrcode? ( media-gfx/zbar )
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46
	virtual/pkgconfig
"

DOCS=( AUTHORS CHANGELOG HACKING )

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	my_rm_loc() {
		sed -i -e "s:../translations/${PN}_${1}.\(ts\|qm\)::" src/src.pro || die
		rm "translations/${PN}_${1}.ts" || die
	}

	l10n_find_plocales_changes 'translations' "${PN}_" '.ts'

	if [[ -n "$(l10n_get_locales)" ]]; then
		l10n_for_each_disabled_locale_do my_rm_loc
		$(qt4_get_bindir)/lrelease src/src.pro || die
	fi

	epatch_user
}

src_configure() {
	# TRANSDIR_SYSTEM is for bug #385671
	eqmake4 \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		TRANSDIR_MERKAARTOR="${EPREFIX}/usr/share/${PN}/translations" \
		TRANSDIR_SYSTEM="${EPREFIX}/usr/share/qt4/translations" \
		SYSTEM_QTSA=1 \
		SYSTEM_QUAZIP=1 \
		NODEBUG="$(usex debug '0' '1')" \
		GEOIMAGE="$(usex exif '1' '0')" \
		GPSDLIB="$(usex gps '1' '0')" \
		LIBPROXY="$(usex libproxy '1' '0')" \
		ZBAR="$(usex qrcode '1' '0')" \
		Merkaartor.pro
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
