# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )
PYTHON_REQ_USE="sqlite"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN^^}.git"
	inherit git-r3
else
	SRC_URI="https://qgis.org/downloads/${P}.tar.bz2
		examples? ( https://qgis.org/downloads/data/qgis_sample_data.tar.gz -> qgis_sample_data-2.8.14.tar.gz )"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake python-single-r1 xdg

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="https://www.qgis.org/"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="3d examples georeferencer grass hdf5 mapserver netcdf opencl oracle pdal polar postgres python qml serial"

REQUIRED_USE="${PYTHON_REQUIRED_USE} mapserver? ( python )"

# Disabling test suite because upstream disallow running from install path
RESTRICT="test"

# 3.22.5+ *does* support GRASS 8 but we can't enable it yet because of
# https://github.com/OSGeo/grass/pull/2269 (=> unresolved SONAME dependencies)
# Keep an eye on that bug / a fixed GRASS release and readd support
# by unrestricting the dep in ${COMMON_DEPEND} once it's fixed!
# (No need to change the supported GRASS versions in src_configure b/c
# it won't find GRASS 8 with this dependency set.)
COMMON_DEPEND="
	app-crypt/qca:2[qt5(+),ssl]
	>=dev-db/spatialite-4.2.0
	dev-db/sqlite:3
	dev-libs/expat
	dev-libs/libzip:=
	dev-libs/protobuf:=
	dev-libs/qtkeychain[qt5(+)]
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtpositioning:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-gfx/exiv2:=
	>=sci-libs/gdal-3.0.4:=[geos]
	sci-libs/geos
	sci-libs/libspatialindex:=
	sys-libs/zlib
	>=sci-libs/proj-4.9.3:=
	>=x11-libs/qscintilla-2.10.1:=[qt5(+)]
	>=x11-libs/qwt-6.1.2:6=[qt5(+),svg]
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
	pdal? ( sci-libs/pdal:= )
	polar? ( >=x11-libs/qwtpolar-1.1.1-r1[qt5(+)] )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/future[${PYTHON_USEDEP}]
			dev-python/httplib2[${PYTHON_USEDEP}]
			dev-python/jinja[${PYTHON_USEDEP}]
			dev-python/markupsafe[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/owslib[${PYTHON_USEDEP}]
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/PyQt5[designer,gui,network,positioning,printsupport,sql,svg,widgets,${PYTHON_USEDEP}]
			dev-python/python-dateutil[${PYTHON_USEDEP}]
			dev-python/pytz[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			>=dev-python/qscintilla-python-2.10.1[qt5(+),${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			<dev-python/sip-5:=[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
			>=sci-libs/gdal-2.2.3[python,${PYTHON_USEDEP}]
			postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
		')
	)
	qml? ( dev-qt/qtdeclarative:5 )
	serial? ( dev-qt/qtserialport:5 )
"
DEPEND="${COMMON_DEPEND}
	dev-qt/qttest:5
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${COMMON_DEPEND}
	sci-geosciences/gpsbabel
"
BDEPEND="
	${PYTHON_DEPS}
	dev-qt/linguist-tools:5
	sys-devel/bison
	sys-devel/flex
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DQGIS_MANUAL_SUBDIR=share/man/
		-DQGIS_LIB_SUBDIR=$(get_libdir)
		-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis
		-DQWT_INCLUDE_DIR=/usr/include/qwt6
		-DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6-qt5.so
		-DQGIS_QML_SUBDIR=/usr/$(get_libdir)/qt5/qml
		-DPEDANTIC=OFF
		-DUSE_CCACHE=OFF
		-DWITH_ANALYSIS=ON
		-DWITH_APIDOC=OFF
		-DWITH_GUI=ON
		-DWITH_INTERNAL_MDAL=ON # not packaged, bug 684538
		-DWITH_QSPATIALITE=ON
		-DENABLE_TESTS=OFF
		-DWITH_3D=$(usex 3d)
		-DWITH_GSL=$(usex georeferencer)
		$(cmake_use_find_package hdf5 HDF5)
		-DWITH_SERVER=$(usex mapserver)
		$(cmake_use_find_package netcdf NetCDF)
		-DUSE_OPENCL=$(usex opencl)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_QWTPOLAR=$(usex polar)
		-DWITH_PDAL=$(usex pdal)
		-DWITH_POSTGRESQL=$(usex postgres)
		-DWITH_BINDINGS=$(usex python)
		-DWITH_CUSTOM_WIDGETS=$(usex python)
		-DWITH_QUICK=$(usex qml)
		-DWITH_QT5SERIALPORT=$(usex serial)
		-DWITH_QTWEBKIT=OFF
	)

	# We list all supported versions *by upstream for this version*
	# here, even if we're not allowing it (e.g. bugs for now), so
	# we enable/disable all the right versions. This is so qgis doesn't
	# try to automatically use a version the build system knows about.
	local supported_grass_versions=( 7 8 )
	if use grass; then
		# We can do this because we have a := dep on grass &
		# it changes subslot (ABI) when major versions change, so
		# the logic here doesn't end up becoming stale.
		readarray -d'-' -t f <<<"$(best_version sci-geosciences/grass)"
		readarray -d'.' -t v <<<"${f[2]}"
		grassdir="grass${v[0]}${v[1]}"

		GRASSDIR=/usr/$(get_libdir)/${grassdir}

		einfo "Supported versions: ${supported_grass_versions[@]}"
		einfo "Found GRASS version: ${v[0]}*"

		local known_grass_version
		# GRASS isn't slotted (in Gentoo, anyway) so we pick
		# the best version we can to build against, and disable the others.
		for known_grass_version in "${supported_grass_versions[@]}" ; do
			case "${known_grass_version}" in
				"${v[0]}")
					einfo "GRASS version ${known_grass_version} is supported. Enabling."
					mycmakeargs+=(
						"-DGRASS_PREFIX${known_grass_version}=${GRASSDIR}"
						"-DWITH_GRASS${known_grass_version}=ON"
					)
					;;
				*)
					einfo "GRASS version ${known_grass_version} is not supported or not latest found. Disabling."
					mycmakeargs+=(
						"-DWITH_GRASS${known_grass_version}=OFF"
					)
					;;
			esac
		done
	else
		local known_grass_version
		for known_grass_version in "${supported_grass_versions[@]}" ; do
			mycmakeargs+=(
				"-DWITH_GRASS${known_grass_version}=OFF"
			)
		done
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
