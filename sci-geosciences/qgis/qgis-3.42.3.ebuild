# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release  # RelWithDebInfo enables debug logging

PYTHON_COMPAT=( python3_{11..13} )
PYTHON_REQ_USE="sqlite"

# We only package the LTS releases right now
# We could package more but would ideally only stabilise the LTS ones
# at least.

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN^^}.git"
	inherit git-r3
else
	SRC_URI="https://qgis.org/downloads/${P}.tar.bz2
		examples? ( https://qgis.org/downloads/data/qgis_sample_data.tar.gz -> qgis_sample_data-2.8.14.tar.gz )"
	KEYWORDS="~amd64"
fi
inherit cmake flag-o-matic python-single-r1 xdg

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="https://www.qgis.org/"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="3d doc examples +georeferencer grass hdf5 mapserver netcdf opencl oracle pdal postgres python qml test webengine"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	mapserver? ( python )
"
# 	test? ( postgres )

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=app-crypt/qca-2.3.7:2[qt6(+),ssl]
	dev-cpp/nlohmann_json
	>=dev-db/spatialite-4.2.0
	dev-db/sqlite:3
	dev-libs/expat
	dev-libs/libzip:=
	dev-libs/protobuf:=
	>=dev-libs/qtkeychain-0.14.1-r1:=[qt6(+)]
	dev-qt/qtbase:6[concurrent,gui,network,sql,ssl,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qtpositioning:6
	dev-qt/qtserialport:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6[designer]
	dev-vcs/git
	media-gfx/exiv2:=
	>=sci-libs/gdal-3.0.4:=[geos,spatialite,sqlite]
	sci-libs/geos
	sci-libs/libspatialindex:=
	>=sci-libs/proj-8.1:=
	sys-libs/zlib
	>=dev-python/qscintilla-2.14.1-r1[qt6(+)]
	>=x11-libs/qwt-6.2.0-r3:=[polar(+),qt6(+),svg(+)]
	3d? ( dev-qt/qt3d:6 )
	georeferencer? ( sci-libs/gsl:= )
	grass? ( sci-geosciences/grass:= )
	hdf5? ( sci-libs/hdf5:= )
	mapserver? ( dev-libs/fcgi )
	netcdf? ( sci-libs/netcdf:= )
	opencl? ( virtual/opencl )
	oracle? (
		dev-db/oracle-instantclient:=
		sci-libs/gdal:=[oracle]
	)
	pdal? ( sci-libs/pdal:= )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		>=sci-libs/gdal-2.2.3[python,${PYTHON_SINGLE_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/httplib2[${PYTHON_USEDEP}]
			dev-python/jinja2[${PYTHON_USEDEP}]
			dev-python/markupsafe[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/owslib[${PYTHON_USEDEP}]
			dev-python/pygments[${PYTHON_USEDEP}]
			dev-python/pyqt6[designer,gui,multimedia,network,positioning,printsupport,serialport,sql,svg,widgets,${PYTHON_USEDEP}]
			dev-python/python-dateutil[${PYTHON_USEDEP}]
			dev-python/pytz[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/qscintilla[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
			dev-python/sip:=[${PYTHON_USEDEP}]
			postgres? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
		')
	)
	qml? ( dev-qt/qtdeclarative:6 )
	webengine? ( dev-qt/qtwebengine:6 )
"
DEPEND="${COMMON_DEPEND}
	test? ( python? (
		app-text/poppler[cairo,utils]
		app-text/qpdf
	) )
"
RDEPEND="${COMMON_DEPEND}
	sci-geosciences/gpsbabel
"
BDEPEND="${PYTHON_DEPS}
	app-alternatives/lex
	app-alternatives/yacc
	dev-qt/qttools:6[linguist]
	doc? ( app-text/doxygen )
	test? ( python? (
		$(python_gen_cond_dep '
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/nose2[${PYTHON_USEDEP}]
			dev-python/psycopg:2[${PYTHON_USEDEP}]
			dev-python/pyqt6[${PYTHON_USEDEP},testlib]
		')
	) )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.42.2-testReportDir.patch"
	# Fixes pulled from upstream branches, see bug #955031
	"${FILESDIR}/${P}-fix-qt6-heatmap.patch"
	"${FILESDIR}/${P}-fix-qt6-qgsserver-getmap.patch"
)

src_prepare() {
	cmake_src_prepare
	# Tests want to be run inside a git repo
	if [[ ${PV} != *9999* ]]; then
		if use test; then
			git config --global --add safe.directory "${S}" || die
			git init -q || die
			git config --local gc.auto 0 || die
			git config --local user.email "larry@gentoo.org" || die
			git config --local user.name "Larry the Cow" || die
			git add . || die

			git commit -m "init" || die
		fi
	fi
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/862660
	# https://github.com/qgis/QGIS/issues/56859
	#
	# Do not trust with LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DQGIS_MANUAL_SUBDIR=share/man/
		-DQGIS_LIB_SUBDIR=$(get_libdir)
		-DQGIS_PLUGIN_SUBDIR=$(get_libdir)/qgis

		# -DQWT_INCLUDE_DIR=/usr/include/qwt6
		# -DQWT_LIBRARY=/usr/$(get_libdir)/libqwt6-qt5.so
		# -DQGIS_QML_SUBDIR=/usr/$(get_libdir)/qt5/qml

		-DPEDANTIC=OFF
		-DUSE_CCACHE=OFF
		-DUSE_PRECOMPILED_HEADERS=OFF
		-DWITH_DRACO=OFF
		-DWITH_QTWEBKIT=OFF
		-DWITH_INTERNAL_NLOHMANN_JSON=OFF
		-DBUILD_WITH_QT6=ON
		-DWITH_ANALYSIS=ON
		-DWITH_DESKTOP=ON
		-DWITH_GUI=ON
		-DWITH_INTERNAL_MDAL=ON # not packaged, bug 684538
		-DWITH_QSPATIALITE=ON
		-DWITH_QWTPOLAR=ON
		-DWITH_3D=$(usex 3d)
		-DWITH_APIDOC=$(usex doc)
		-DENABLE_TESTS=$(usex test)
		-DWITH_GSL=$(usex georeferencer)
		$(cmake_use_find_package hdf5 HDF5)
		-DWITH_SERVER=$(usex mapserver)
		$(cmake_use_find_package netcdf NetCDF)
		-DUSE_OPENCL=$(usex opencl)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_PDAL=$(usex pdal)
		-DWITH_POSTGRESQL=$(usex postgres)
		-DWITH_BINDINGS=$(usex python)
		-DWITH_PYTHON=$(usex python)
		-DWITH_CUSTOM_WIDGETS=$(usex python)
		-DWITH_QUICK=$(usex qml)
		-DWITH_QTWEBENGINE=$(usex webengine)
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

		einfo "Supported versions: ${supported_grass_versions[*]}"
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

	use python && mycmakeargs+=( -DBINDINGS_GLOBAL_INSTALL=ON )

	cmake_src_configure
}

src_test() {
	addwrite "/proc/self/mem"
	addwrite "/proc/self/task/"
	addwrite "/dev/fuse"

	local -x CMAKE_SKIP_TESTS=(
		PyQgsAFSProvider$
		PyQgsAnnotation$
		PyQgsAuthenticationSystem$
		PyQgsAuxiliaryStorage$
		PyQgsBlockingNetworkRequest$
		PyQgsBlockingProcess$
		PyQgsCodeEditor$
		PyQgsDataItemProviderRegistry$
		PyQgsDelimitedTextProvider$
		PyQgsEditWidgets$
		PyQgsElevationProfileCanvas$
		PyQgsEmbeddedSymbolRenderer$
		PyQgsExternalStorageAwsS3$
		PyQgsExternalStorageWebDav$
		PyQgsFileDownloader$
		PyQgsFloatingWidget$
		PyQgsGeometryTest$
		PyQgsGoogleMapsGeocoder$
		PyQgsGroupLayer$
		PyQgsLayerDefinition$
		PyQgsLayoutHtml$
		PyQgsLayoutLegend$
		PyQgsLayoutMap$
		PyQgsLineSymbolLayers$
		PyQgsMapBoxGlStyleConverter$
		PyQgsMapLayerComboBox$
		PyQgsMapLayerProxyModel$
		PyQgsMemoryProvider$
		PyQgsNetworkAccessManager$
		PyQgsOGRProvider$
		PyQgsOGRProviderGpkg$
		PyQgsPainting$
		PyQgsPalLabelingCanvas$
		PyQgsPalLabelingLayout$
		PyQgsPalLabelingPlacement$
		PyQgsPlot$
		PyQgsPointCloudAttributeByRampRenderer$
		PyQgsPointCloudClassifiedRenderer$
		PyQgsPointCloudRgbRenderer$
		PyQgsProcessExecutablePt1$
		PyQgsProcessExecutablePt2$
		PyQgsProcessingAlgRunner$
		PyQgsProcessingInPlace$
		PyQgsProcessingPackageLayersAlgorithm$
		PyQgsProcessingParameters$
		PyQgsProject$
		PyQgsPythonProvider$
		PyQgsRasterFileWriter$
		PyQgsRasterLayer$
		PyQgsRasterLayerRenderer$
		PyQgsSelectiveMasking$
		PyQgsSettings$
		PyQgsSettingsEntry$
		PyQgsShapefileProvider$
		PyQgsSpatialiteProvider$
		PyQgsStyleModel$
		PyQgsSvgCache$
		PyQgsSymbolLayerReadSld$
		PyQgsTextRenderer$
		PyQgsVectorFileWriter$
		PyQgsVectorLayerCache$
		PyQgsVectorLayerEditBuffer$
		PyQgsVectorLayerEditUtils$
		PyQgsVectorLayerProfileGenerator$
		PyQgsWFSProvider$
		TestQgsRandomMarkerSymbolLayer$
		qgis_sip_uptodate$
		test_3d_3drendering$
		test_3d_layout3dmap$
		test_3d_mesh3drendering$
		test_3d_pointcloud3drendering$
		test_3d_tessellator$
		test_analysis_gcptransformer$
		test_app_advanceddigitizing$
		test_authmethod_authoauth2method$
		test_core_mapdevicepixelratio$
		test_core_ogcutils$
		test_core_openclutils$
		test_core_vectortilelayer$
		test_gui_dockwidget$
		test_gui_ogrprovidergui$

		PyQgsDocCoverage$
		PyQgsSipCoverage$
	)

	CMAKE_SKIP_TESTS+=(
		test_core_blendmodes$
		test_core_callout$
		test_core_compositionconverter$
		test_core_dataitem$
		test_core_expression$
		test_core_gdalutils$
		test_core_labelingengine$
		test_core_layoutmap$
		test_core_layoutmapoverview$
		test_core_layoutpicture$
		test_core_linefillsymbol$
		test_core_maprendererjob$
		test_core_maprotation$
		test_core_meshlayer$
		test_core_meshlayerrenderer$
		test_core_networkaccessmanager$
		test_core_pointcloudlayerexporter$
		test_core_project$
		test_core_rastercontourrenderer$
		test_core_rasterlayer$
		test_core_simplemarker$
		test_core_tiledownloadmanager$
		test_gui_processinggui$
		test_gui_filedownloader$
		test_gui_newdatabasetablewidget$
		test_gui_queryresultwidget$
		test_analysis_processingalgspt2$
		test_analysis_meshcontours$
		test_analysis_triangulation$
		test_analysis_processing$
		test_provider_wcsprovider$
		test_app_maptoolcircularstring$
		test_app_vertextool$
	)

	if ! use netcdf; then
		CMAKE_SKIP_TESTS+=(
			test_core_gdalprovider$
		)
	fi

	if ! use hdf5; then
		CMAKE_SKIP_TESTS+=(
			test_gui_meshlayerpropertiesdialog$
			test_app_maptooleditmesh$
		)
	fi

	if ! use python || ! use postgres; then
		CMAKE_SKIP_TESTS+=(
			ProcessingGrassAlgorithmsRasterTestPt2$
			ProcessingCheckValidityAlgorithmTest$
			ProcessingGdalAlgorithmsGeneralTest$
			ProcessingGdalAlgorithmsRasterTest$
			ProcessingGdalAlgorithmsVectorTest$
			ProcessingGeneralTest$
			ProcessingGenericAlgorithmsTest$
			ProcessingGrassAlgorithmsImageryTest$
			ProcessingGrassAlgorithmsRasterTestPt1$
			ProcessingGrassAlgorithmsVectorTest$
			ProcessingGuiTest$
			ProcessingModelerTest$
			ProcessingParametersTest$
			ProcessingProjectProviderTest$
			ProcessingQgisAlgorithmsTestPt1$
			ProcessingQgisAlgorithmsTestPt2$
			ProcessingQgisAlgorithmsTestPt3$
			ProcessingQgisAlgorithmsTestPt4$
			ProcessingQgisAlgorithmsTestPt5$
			ProcessingQgisAlgorithmsTestPt5$
			ProcessingScriptUtilsTest$
			ProcessingToolsTest$
		)
	fi

	local myctestargs=(
		--output-on-failure
		-j1
	)

	xdg_environment_reset

	local -x QGIS_CONTINUOUS_INTEGRATION_RUN=true
	local -x QT_QPA_PLATFORM=offscreen

	cmake_src_test
}

src_install() {
	if use test; then
		git config --global --add safe.directory "${S}" || die
	fi
	cmake_src_install

	insinto /usr/share/mime/packages
	doins debian/qgis.xml

	if use examples; then
		docinto examples
		dodoc -r "${WORKDIR}"/qgis_sample_data/.
		docompress -x "/usr/share/doc/${PF}/examples"
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
