# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/qgis/qgis-1.7.0.ebuild,v 1.10 2014/12/28 16:51:33 titanofold Exp $

EAPI=3

PYTHON_USE_WITH="sqlite"
PYTHON_DEPEND="python? 2"
inherit python cmake-utils eutils multilib

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="http://www.qgis.org/"
SRC_URI="http://qgis.org/downloads/${P}.tar.bz2
	examples? ( http://download.osgeo.org/qgis/data/qgis_sample_data.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples gps grass gsl postgres python spatialite test"

RDEPEND="
	dev-libs/expat
	sci-geosciences/gpsbabel
	>=sci-libs/gdal-1.6.1[geos,python?]
	sci-libs/geos
	sci-libs/gsl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4
	x11-libs/qwt:5[svg]
	x11-libs/qwtpolar
	grass? ( >=sci-geosciences/grass-6.4.0_rc6[python?] )
	postgres? ( >=dev-db/postgresql-8.4 )
	python? ( dev-python/PyQt4[X,sql,svg] )
	spatialite? (
		dev-db/sqlite:3
		dev-db/spatialite
	)"

DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

DOCS=( BUGS ChangeLog CODING.pdf README )
PATCHES=(
	"${FILESDIR}/${PN}-1.7.0-avoid-deprecated-pyqtconfig.patch"
)

# Does not find the test binaries at all
RESTRICT="test"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	local mycmakeargs+=(
		"-DQGIS_MANUAL_SUBDIR=/share/man/"
		"-DBUILD_SHARED_LIBS=ON"
		"-DBINDINGS_GLOBAL_INSTALL=ON"
		"-DQGIS_LIB_SUBDIR=$(get_libdir)"
		"-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis"
		"-DWITH_INTERNAL_SPATIALITE=OFF"
		"-DWITH_INTERNAL_QWTPOLAR=OFF"
		"-DPEDANTIC=OFF"
		"-DWITH_APIDOC=OFF"
		$(cmake-utils_use_with postgres POSTGRESQL)
		$(cmake-utils_use_with grass GRASS)
		$(cmake-utils_use_with python BINDINGS)
		$(cmake-utils_use python BINDINGS_GLOBAL_INSTALL)
		$(cmake-utils_use_with spatialite SPATIALITE)
		$(cmake-utils_use_enable test TESTS)
	)
	use grass && mycmakeargs+=( "-DGRASS_PREFIX=/usr/" )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newicon images/icons/qgis-icon.png qgis.png || die
	make_desktop_entry qgis "Quantum GIS" qgis

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${WORKDIR}"/qgis_sample_data/* || die "Unable to install examples"
	fi
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use an external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	fi
}
