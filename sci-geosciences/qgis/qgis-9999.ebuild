# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="sqlite"

# We only package the LTS releases right now
# We could package more but would ideally only stabilise the LTS ones
# at least.

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/${PN}/${PN^^}.git"
	inherit git-r3
else
	SRC_URI="https://qgis.org/downloads/${P}.tar.bz2
		examples? ( https://qgis.org/downloads/data/qgis_sample_data.tar.gz -> qgis_sample_data-2.8.14.tar.gz )"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake python-single-r1 virtualx xdg

DESCRIPTION="User friendly Geographic Information System"
HOMEPAGE="https://www.qgis.org/"

LICENSE="GPL-2+ GPL-3+"
SLOT="0"
IUSE="3d examples georeferencer grass hdf5 mapserver netcdf opencl oracle pdal polar postgres python qml serial test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	mapserver? ( python )
	test? ( postgres )
"

# Disabling test suite because upstream disallow running from install path
RESTRICT="!test? ( test )"

# At some point the dependency on qwtpolar should be
# replaced with a dependency on qwt[polar]. Currently
# it does not build with qwt-6.2[polar] though.
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
	polar? ( >=x11-libs/qwtpolar-1.1.1-r1[qt5(+)] )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		>=sci-libs/gdal-2.2.3[python,${PYTHON_SINGLE_USEDEP}]
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
			dev-python/sip:=[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
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
	test? (
		$(python_gen_cond_dep '
			dev-python/PyQt5[${PYTHON_USEDEP},testlib]
			dev-python/nose2[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
		')
	)
"

src_prepare() {
	cmake_src_prepare
	# Tests want to be run inside a git repo
	if [[ ${PV} != *9999* ]]; then
		if use test; then
			git init -q || die
			git config user.email "larry@gentoo.org" || die
			git config user.name "Larry the Cow" || die
			git add . || die
			git commit -m "init" || die
		fi
	fi
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
		-DENABLE_TESTS=$(usex test)
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

	use python && mycmakeargs+=( -DBINDINGS_GLOBAL_INSTALL=ON )

	# bugs 612956, 648726
	addpredict /dev/dri/renderD128
	addpredict /dev/dri/renderD129

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# test_core_gdalprovider - see https://github.com/qgis/QGIS/pull/47887
		-E '(ProcessingGuiTest$|ProcessingQgisAlgorithmsTestPt1$|ProcessingQgisAlgorithmsTestPt2$|ProcessingQgisAlgorithmsTestPt3$|ProcessingQgisAlgorithmsTestPt4$|ProcessingGdalAlgorithmsRasterTest$|ProcessingGdalAlgorithmsVectorTest$|ProcessingGrass7AlgorithmsImageryTest$|ProcessingGrass7AlgorithmsRasterTestPt1$|ProcessingGrass7AlgorithmsRasterTestPt2$|ProcessingGrass7AlgorithmsVectorTest$|ProcessingOtbAlgorithmsTest$|test_core_callout$|test_core_compositionconverter$|test_core_expression$|test_core_gdalprovider$|test_core_gdalutils$|test_core_geonodeconnection$|test_core_imagecache$|test_core_labelingengine$|test_core_layout$|test_core_layoutcontext$|test_core_layouthtml$|test_core_layoutlabel$|test_core_layoutmanualtable$|test_core_layoutmap$|test_core_layoutmapgrid$|test_core_layoutmapoverview$|test_core_layoutmultiframe$|test_core_layoutpicture$|test_core_linefillsymbol$|test_core_mapdevicepixelratio$|test_core_maprendererjob$|test_core_meshlayer$|test_core_meshlayerrenderer$|test_core_networkaccessmanager$|test_core_pointpatternfillsymbol$|test_core_rastercontourrenderer$|test_core_rasterlayer$|test_core_simplemarker$|test_core_style$|test_core_svgmarker$|test_core_tiledownloadmanager$|test_core_ziplayer$|test_core_coordinatereferencesystem$|test_core_geometry$|test_gui_dualview$|test_gui_htmlwidgetwrapper$|test_gui_processinggui$|test_gui_filedownloader$|test_gui_ogrprovidergui$|test_gui_queryresultwidget$|test_gui_listwidget$|test_3d_3drendering$|test_3d_tessellator$|test_analysis_processingalgspt1$|test_analysis_processingalgspt2$|test_analysis_meshcontours$|test_analysis_triangulation$|test_analysis_processing$|test_provider_wcsprovider$|test_provider_postgresconn$|test_provider_virtualrasterprovider$|test_app_qgisappclipboard$|test_app_fieldcalculator$|test_app_maptoolcircularstring$|test_app_vertextool$|PyQgsLocalServer$|PyQgsAFSProvider$|PyQgsPythonProvider$|PyQgsAnnotation$|PyQgsAuthenticationSystem$|PyQgsAuthBasicMethod$|PyQgsDataItem$|PyQgsDelimitedTextProvider$|PyQgsEmbeddedSymbolRenderer$|PyQgsExpressionBuilderWidget$|PyQgsExternalStorageWebDAV$|PyQgsGeometryTest$|PyQgsGoogleMapsGeocoder$|PyQgsImageCache$|PyQgsLayout$|PyQgsLayoutHtml$|PyQgsLayoutLegend$|PyQgsLayoutMap$|PyQgsLayoutMapGrid$|PyQgsLayoutMapOverview$|PyQgsMapClippingUtils$|PyQgsMapLayerComboBox$|PyQgsMapLayerProxyModel$|PyQgsMemoryProvider$|PyQgsOGRProviderGpkg$|PyQgsPalLabelingCanvas$|PyQgsPalLabelingLayout$|PyQgsPalLabelingPlacement$|PyQgsPointCloudAttributeByRampRenderer$|PyQgsPointCloudClassifiedRenderer$|PyQgsPointCloudExtentRenderer$|PyQgsPointCloudRgbRenderer$|PyQgsProcessExecutable$|PyQgsProcessingInPlace$|TestQgsRandomMarkerSymbolLayer$|PyQgsRasterLayer$|PyQgsRasterLayerRenderer$|PyQgsRasterResampler$|PyQgsRulebasedRenderer$|PyQgsShapefileProvider$|PyQgsSvgCache$|PyQgsOGRProvider$|PyQgsSpatialiteProvider$|PyQgsTaskManager$|PyQgsVectorFileWriter$|PyQgsVectorLayer$|PyQgsVectorLayerCache$|PyQgsVectorLayerEditBuffer$|PyQgsVectorLayerEditBufferGroup$|PyQgsVectorLayerProfileGenerator$|PyQgsVectorLayerSelectedFeatureSource$|PyQgsVectorLayerShapefile$|PyQgsVirtualLayerProvider$|PyQgsWFSProvider$|PyQgsOapifProvider$|PyQgsDBManagerGpkg$|PyQgsAuxiliaryStorage$|PyQgsFieldValidator$|PyQgsSelectiveMasking$|PyQgsPalLabelingServer$|PyQgsServerWMSGetMap$|PyQgsServerWMSGetLegendGraphic$|PyQgsServerWMSGetPrint$|PyQgsServerWMSGetPrintExtra$|PyQgsServerWMSGetPrintOutputs$|PyQgsServerWMSGetPrintAtlas$|PyQgsServerWMSDimension$|PyQgsServerAccessControlWMS$|PyQgsServerAccessControlWFS$|PyQgsServerAccessControlWFSTransactional$|PyQgsServerCacheManager$|PyQgsServerWMS$|PyQgsServerWMTS$|PyQgsServerWFS$|qgis_sipify$|qgis_sip_include$|qgis_sip_uptodate$|qgis_doxygen_order$|test_core_authmanager$)'

		--output-on-failure
	)

	virtx cmake_src_test -j1
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
