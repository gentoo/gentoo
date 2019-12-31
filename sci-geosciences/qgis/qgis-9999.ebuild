# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite"
QT_MIN_VER="5.9.4"

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN^^}.git"
	inherit git-r3
else
	SRC_URI="https://qgis.org/downloads/${P}.tar.bz2
		examples? ( https://qgis.org/downloads/data/qgis_sample_data.tar.gz -> qgis_sample_data-2.8.14.tar.gz )"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils desktop python-single-r1 qmake-utils xdg

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="https://www.qgis.org/"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="3d examples georeferencer grass hdf5 mapserver netcdf opencl oracle polar postgres python qml webkit"

REQUIRED_USE="${PYTHON_REQUIRED_USE} mapserver? ( python )"

BDEPEND="
	${PYTHON_DEPS}
	>=dev-qt/linguist-tools-${QT_MIN_VER}:5
	sys-devel/bison
	sys-devel/flex
"
COMMON_DEPEND="
	app-crypt/qca:2[qt5(+),ssl]
	>=dev-db/spatialite-4.2.0
	dev-db/sqlite:3
	dev-libs/expat
	dev-libs/libzip:=
	dev-libs/qtkeychain[qt5(+)]
	>=dev-qt/designer-${QT_MIN_VER}:5
	>=dev-qt/qtconcurrent-${QT_MIN_VER}:5
	>=dev-qt/qtcore-${QT_MIN_VER}:5
	>=dev-qt/qtgui-${QT_MIN_VER}:5
	>=dev-qt/qtnetwork-${QT_MIN_VER}:5[ssl]
	>=dev-qt/qtpositioning-${QT_MIN_VER}:5
	>=dev-qt/qtprintsupport-${QT_MIN_VER}:5
	>=dev-qt/qtserialport-${QT_MIN_VER}:5
	>=dev-qt/qtsvg-${QT_MIN_VER}:5
	>=dev-qt/qtsql-${QT_MIN_VER}:5
	>=dev-qt/qtwidgets-${QT_MIN_VER}:5
	>=dev-qt/qtxml-${QT_MIN_VER}:5
	media-gfx/exiv2:=
	>=sci-libs/gdal-2.2.3:=[geos]
	sci-libs/geos
	sci-libs/libspatialindex:=
	sci-libs/proj:=
	>=x11-libs/qscintilla-2.10.1:=[qt5(+)]
	>=x11-libs/qwt-6.1.2:6=[qt5(+),svg]
	3d? ( >=dev-qt/qt3d-${QT_MIN_VER}:5 )
	georeferencer? ( sci-libs/gsl:= )
	grass? ( =sci-geosciences/grass-7*:= )
	hdf5? ( sci-libs/hdf5:= )
	mapserver? ( dev-libs/fcgi )
	netcdf? ( sci-libs/netcdf:= )
	opencl? ( virtual/opencl )
	oracle? (
		dev-db/oracle-instantclient:=
		sci-libs/gdal:=[oracle]
	)
	polar? ( >=x11-libs/qwtpolar-1.1.1-r1[qt5(+)] )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		dev-python/future[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/markupsafe[${PYTHON_USEDEP}]
		dev-python/owslib[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/PyQt5[designer,network,sql,svg,webkit?,${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		>=dev-python/qscintilla-python-2.10.1[qt5(+),${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/sip:=[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		>=sci-libs/gdal-2.2.3[python,${PYTHON_USEDEP}]
		postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	)
	qml? ( >=dev-qt/qtdeclarative-${QT_MIN_VER}:5 )
	webkit? ( >=dev-qt/qtwebkit-5.9.1:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qttest-${QT_MIN_VER}:5
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${COMMON_DEPEND}
	sci-geosciences/gpsbabel
"

# Disabling test suite because upstream disallow running from install path
RESTRICT="test"

PATCHES=(
	# git master
	"${FILESDIR}/${PN}-3.10.0-cmake-lib-suffix.patch"
	# TODO upstream
	"${FILESDIR}/${PN}-3.4.7-featuresummary.patch"
	"${FILESDIR}/${PN}-3.4.7-default-qmldir.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQGIS_MANUAL_SUBDIR=share/man/
		-DQGIS_LIB_SUBDIR=$(get_libdir)
		-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis
		-DQWT_INCLUDE_DIR=/usr/include/qwt6
		-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6-qt5.so
		-DPEDANTIC=OFF
		-DUSE_CCACHE=OFF
		-DWITH_ANALYSIS=ON
		-DWITH_APIDOC=OFF
		-DWITH_GUI=ON
		-DWITH_INTERNAL_MDAL=ON # not packaged, bug 684538
		-DWITH_QSPATIALITE=ON
		-DENABLE_TESTS=OFF
		-DWITH_3D=$(usex 3d)
		-DWITH_GEOREFERENCER=$(usex georeferencer)
		-DWITH_GRASS7=$(usex grass)
		$(cmake-utils_use_find_package hdf5 HDF5)
		-DWITH_SERVER=$(usex mapserver)
		$(cmake-utils_use_find_package netcdf NetCDF)
		-DUSE_OPENCL=$(usex opencl)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_QWTPOLAR=$(usex polar)
		-DWITH_POSTGRESQL=$(usex postgres)
		-DWITH_BINDINGS=$(usex python)
		-DWITH_CUSTOM_WIDGETS=$(usex python)
		-DWITH_QUICK=$(usex qml)
		-DWITH_QTWEBKIT=$(usex webkit)
	)

	if use grass; then
		mycmakeargs+=(
			-DGRASS_PREFIX7=/usr/$(get_libdir)/grass70
		)
	fi

	use python && mycmakeargs+=( -DBINDINGS_GLOBAL_INSTALL=ON )

	# bugs 612956, 648726
	addpredict /dev/dri/renderD128
	addpredict /dev/dri/renderD129

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	insinto /usr/share/mime/packages
	doins debian/qgis.xml

	if use examples; then
		docinto examples
		dodoc -r "${WORKDIR}"/qgis_sample_data/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	if use python; then
		python_optimize
		python_optimize "${ED}"/usr/share/qgis/python
	fi

	if use grass; then
		python_fix_shebang "${ED}"/usr/share/qgis/grass/scripts
	fi
}

pkg_postinst() {
	if use postgres; then
		elog "If you don't intend to use an external PostGIS server"
		elog "you should install:"
		elog "   dev-db/postgis"
	elif use python; then
		elog "Support of PostgreSQL is disabled."
		elog "But some installed python-plugins import the psycopg2 module."
		elog "If you do not need these plugins just disable them"
		elog "in the Plugins menu, else you need to set USE=\"postgres\""
	fi

	xdg_pkg_postinst
}
