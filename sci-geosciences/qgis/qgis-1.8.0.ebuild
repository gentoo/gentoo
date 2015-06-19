# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/qgis/qgis-1.8.0.ebuild,v 1.11 2015/04/21 17:44:54 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils gnome2-utils multilib cmake-utils python-single-r1

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"
SRC_URI="http://qgis.org/downloads/${P}.tar.bz2
	examples? ( http://download.osgeo.org/qgis/data/qgis_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bundled-libs examples gps gsl postgres python spatialite test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/expat
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4
	sci-geosciences/gpsbabel
	>=sci-libs/gdal-1.6.1[geos,python?]
	sci-libs/geos
	sci-libs/gsl
	sci-libs/libspatialindex
	sci-libs/proj
	x11-libs/qwt:5[svg]
	!bundled-libs? ( <x11-libs/qwtpolar-1 )
	postgres? ( >=dev-db/postgresql-8.4 )
	python? (
		dev-python/PyQt4[X,sql,svg,${PYTHON_USEDEP}]
		dev-python/sip:=[${PYTHON_USEDEP}]
	)
	spatialite? (
		dev-db/sqlite:3
		dev-db/spatialite
	)"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}/${PN}-1.7.0-avoid-deprecated-pyqtconfig.patch"
	"${FILESDIR}/${PN}-1.8.0-no-python-pyc.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		"-DQGIS_MANUAL_SUBDIR=/share/man/"
		"-DBUILD_SHARED_LIBS=ON"
		"-DQGIS_LIB_SUBDIR=$(get_libdir)"
		"-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis"
		"-DWITH_INTERNAL_SPATIALITE=OFF"
		"-DWITH_INTERNAL_QWTPOLAR=$(usex bundled-libs "ON" "OFF")"
		"-DPEDANTIC=OFF"
		"-DWITH_APIDOC=OFF"
		"-DWITH_GRASS=OFF"
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with python BINDINGS)
		$(cmake-utils_use python BINDINGS_GLOBAL_INSTALL)
		$(cmake-utils_use_with spatialite SPATIALITE)
		$(cmake-utils_use_enable test TESTS)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc BUGS ChangeLog CODING README

	newicon -s 128 images/icons/qgis-icon.png qgis.png
	make_desktop_entry qgis "Quantum GIS " qgis

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/qgis_sample_data/*
	fi

	python_fix_shebang "${D}"/usr/share/qgis/grass/scripts
	python_optimize "${D}"/usr/share/qgis/python/plugins \
		"${D}"/$(python_get_sitedir)/qgis \
		"${D}"/usr/share/qgis/grass/scripts
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use an external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	fi

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
