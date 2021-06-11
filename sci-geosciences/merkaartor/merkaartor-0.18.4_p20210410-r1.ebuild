# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="ar cs de en es et fr hr hu id_ID it ja nl pl pt_BR pt ru sk sv uk vi zh_CN zh_TW"
inherit flag-o-matic l10n qmake-utils xdg-utils

if [[ ${PV} != *9999 ]] ; then
	# Needed for new Proj API support
	# bug #685234
	COMMIT="7ae76834bcba9934f38d85058f7372fc016c1d1c"
	SRC_URI="https://github.com/openstreetmap/merkaartor/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	#SRC_URI="https://github.com/openstreetmap/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/openstreetmap/merkaartor.git"
	inherit git-r3
fi

DESCRIPTION="Qt based map editor for the openstreetmap.org project"
HOMEPAGE="http://www.merkaartor.be https://github.com/openstreetmap/merkaartor"

LICENSE="GPL-2"
SLOT="0"
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
	sci-libs/proj:=
	sys-libs/zlib
	exif? ( media-gfx/exiv2:= )
	gps? ( >=sci-geosciences/gpsd-3.17-r2:= )
	libproxy? ( net-libs/libproxy )
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.18.3-sharedir-pluginsdir.patch ) # bug 621826

DOCS=( AUTHORS CHANGELOG )

src_prepare() {
	default

	rm -r 3rdparty || die "Failed to remove bundled libs"

	my_rm_loc() {
		sed -i -e "s:../translations/${PN}_${1}.\(ts\|qm\)::" src/src.pro || die
		rm "translations/${PN}_${1}.ts" || die
	}

	if [[ -n "$(l10n_get_locales)" ]]; then
		l10n_for_each_disabled_locale_do my_rm_loc
		$(qt5_get_bindir)/lrelease src/src.pro || die
	fi

	# build system expects to be building from git
	if [[ ${PV} != *9999 ]] ; then
		sed -i src/Config.pri -e "s:SION = .*:SION = \"${PV}\":g" || die
	fi
}

src_configure() {
	if has_version "<sci-libs/proj-8.0.0" ; then
		# bug #685234
		append-cppflags -DACCEPT_USE_OF_DEPRECATED_PROJ_API_H
	fi

	# TRANSDIR_SYSTEM is for bug #385671
	local myeqmakeargs=(
		PREFIX="${ED}/usr"
		LIBDIR="${ED}/usr/$(get_libdir)"
		PLUGINS_DIR="/usr/$(get_libdir)/${PN}/plugins"
		SHARE_DIR_PATH="/usr/share/${PN}"
		TRANSDIR_MERKAARTOR="${ED}/usr/share/${PN}/translations"
		TRANSDIR_SYSTEM="${EPREFIX}/usr/share/qt5/translations"
		SYSTEM_QTSA=1
		NODEBUG=$(usex debug 0 1)
		GEOIMAGE=$(usex exif 1 0)
		GPSDLIB=$(usex gps 1 0)
		LIBPROXY=$(usex libproxy 1 0)
		USEWEBENGINE=$(usex webengine 1 0)
	)
	[[ ${PV} != *9999 ]] && myeqmakeargs+=( RELEASE=1 )

	eqmake5 "${myeqmakeargs[@]}" Merkaartor.pro
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
