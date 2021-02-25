# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="sqlite"

if [[ ${PV} = *9999 ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN^^}.git"
	inherit git-r3
else
	SRC_URI="https://qgis.org/downloads/${P}.tar.bz2
		examples? ( https://qgis.org/downloads/data/qgis_sample_data.tar.gz -> qgis_sample_data-2.8.14.tar.gz )"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake desktop python-single-r1 qmake-utils xdg

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="https://www.qgis.org/en/site/"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="3d examples georeferencer grass hdf5 mapserver netcdf opencl oracle polar postgres python qml"

REQUIRED_USE="${PYTHON_REQUIRED_USE} mapserver? ( python )"

BDEPEND="${PYTHON_DEPS}
	dev-qt/linguist-tools:5
	sys-devel/bison
	sys-devel/flex
"
COMMON_DEPEND="
	>=app-crypt/qca-2.3.0:2[ssl]
	>=dev-db/spatialite-4.2.0
	dev-db/sqlite:3
	dev-libs/expat
	dev-libs/libzip:=
	dev-libs/protobuf:=
	dev-libs/qtkeychain:=
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtpositioning:5
	dev-qt/qtprintsupport:5
	dev-qt/qtserialport:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/exiv2:=
	>=sci-libs/gdal-3.0.4:=[geos]
	sci-libs/geos
	sci-libs/libspatialindex:=
	>=sci-libs/proj-6.3.1:=
	sys-libs/zlib
	>=x11-libs/qscintilla-2.10.3:=
	>=x11-libs/qwt-6.1.3-r2:6=[svg]
	3d? ( dev-qt/qt3d:5 )
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
	polar? ( >=x11-libs/qwtpolar-1.1.1-r2 )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/httplib2[${PYTHON_MULTI_USEDEP}]
			dev-python/jinja[${PYTHON_MULTI_USEDEP}]
			dev-python/markupsafe[${PYTHON_MULTI_USEDEP}]
			dev-python/owslib[${PYTHON_MULTI_USEDEP}]
			dev-python/pygments[${PYTHON_MULTI_USEDEP}]
			dev-python/PyQt5[designer,gui,network,printsupport,sql,svg,${PYTHON_MULTI_USEDEP}]
			dev-python/python-dateutil[${PYTHON_MULTI_USEDEP}]
			dev-python/pytz[${PYTHON_MULTI_USEDEP}]
			dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]
			>=dev-python/qscintilla-python-2.10.3[${PYTHON_MULTI_USEDEP}]
			dev-python/requests[${PYTHON_MULTI_USEDEP}]
			dev-python/sip:=[${PYTHON_MULTI_USEDEP}]
			dev-python/six[${PYTHON_MULTI_USEDEP}]
			>=sci-libs/gdal-2.2.3[python,${PYTHON_MULTI_USEDEP}]
			postgres? ( dev-python/psycopg:2[${PYTHON_MULTI_USEDEP}] )
		')
	)
	qml? ( dev-qt/qtdeclarative:5 )
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qttest:5
"
RDEPEND="${COMMON_DEPEND}
	sci-geosciences/gpsbabel
"

# Disabling test suite because upstream disallow running from install path
RESTRICT="test"

PATCHES=(
	# git master
	"${FILESDIR}/${PN}-3.16.0-cmake-lib-suffix.patch"
	# TODO upstream
	"${FILESDIR}/${PN}-3.16.1-featuresummary.patch"
	"${FILESDIR}/${PN}-3.16.1-default-qmldir.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	sed -e "/QtWebKit.*.py/d" \
		-i python/PyQt/CMakeLists.txt || die
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
		$(cmake_use_find_package hdf5 HDF5)
		-DWITH_SERVER=$(usex mapserver)
		$(cmake_use_find_package netcdf NetCDF)
		-DUSE_OPENCL=$(usex opencl)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_QWTPOLAR=$(usex polar)
		-DWITH_POSTGRESQL=$(usex postgres)
		-DWITH_BINDINGS=$(usex python)
		-DWITH_CUSTOM_WIDGETS=$(usex python)
		-DWITH_QUICK=$(usex qml)
		-DWITH_QTWEBKIT=OFF
	)

	if use grass; then
		mycmakeargs+=(
			-DGRASS_PREFIX7=/usr/$(get_libdir)/grass70
		)
	fi

	use python && mycmakeargs+=( -DBINDINGS_GLOBAL_INSTALL=ON ) ||
		mycmakeargs+=( -DWITH_QGIS_PROCESS=OFF ) # FIXME upstream issue #39973

	# bugs 612956, 648726
	addpredict /dev/dri/renderD128
	addpredict /dev/dri/renderD129

	cmake_src_configure
}

src_install() {
	cmake_src_install

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
