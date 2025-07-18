# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{11..13} )
inherit cmake distutils-r1 flag-o-matic java-pkg-opt-2

DESCRIPTION="Translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="https://gdal.org/"
SRC_URI="
	https://download.osgeo.org/${PN}/${PV}/${P}.tar.xz
	test? ( https://download.osgeo.org/${PN}/${PV}/${PN}autotest-${PV}.tar.gz )
"

LICENSE="BSD Info-ZIP MIT"
SLOT="0/37" # subslot is libgdal.so.<SONAME> (and GDAL_SOVERSION in gdal.cmake)
KEYWORDS="~amd64"
IUSE="
	archive armadillo avif blosc cryptopp +curl cpu_flags_arm_neon cpu_flags_x86_avx
	cpu_flags_x86_avx2 cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse4_1
	cpu_flags_x86_ssse3 exprtk fits geos gif gml hdf5 heif java jpeg jpeg2k jpegxl
	lerc libaec libdeflate lz4 lzma mongodb +muparser mysql netcdf odbc openexr
	oracle parquet pdf png postgres python qhull spatialite sqlite test +tools webp
	xls zstd
"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	spatialite? ( sqlite )
"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/expat
	dev-libs/json-c:=
	dev-libs/libxml2:2=
	dev-libs/openssl:=
	media-libs/tiff:=
	>=sci-libs/libgeotiff-1.5.1-r1:=
	>=sci-libs/proj-6.0.0:=
	sys-libs/zlib[minizip(+)]
	archive? ( app-arch/libarchive:= )
	armadillo? ( sci-libs/armadillo:=[lapack] )
	avif? ( media-libs/libavif:= )
	blosc? ( dev-libs/c-blosc:= )
	cryptopp? ( dev-libs/crypto++:= )
	curl? ( net-misc/curl )
	fits? ( sci-libs/cfitsio:= )
	geos? ( >=sci-libs/geos-3.8.0 )
	gif? ( media-libs/giflib:= )
	gml? ( >=dev-libs/xerces-c-3.1:= )
	heif? ( media-libs/libheif:= )
	hdf5? ( >=sci-libs/hdf5-1.6.4:=[cxx,szip] )
	java? (
		>=virtual/jdk-1.8:*
	)
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	jpegxl? ( media-libs/libjxl:= )
	lerc? ( media-libs/lerc:= )
	libaec? ( sci-libs/libaec:= )
	libdeflate? ( app-arch/libdeflate )
	lz4? ( app-arch/lz4:= )
	lzma? ( || (
		app-arch/xz-utils
		app-arch/lzma
	) )
	mongodb? ( dev-db/mongodb:= )
	muparser? ( dev-cpp/muParser:= )
	mysql? ( dev-db/mysql-connector-c:= )
	netcdf? ( sci-libs/netcdf:= )
	odbc? ( dev-db/unixODBC )
	openexr? ( media-libs/openexr:= )
	oracle? ( dev-db/oracle-instantclient:= )
	parquet? ( dev-libs/apache-arrow:=[compute,dataset,parquet,lz4?,zlib,zstd?] )
	pdf? ( app-text/poppler:= )
	png? ( media-libs/libpng:= )
	postgres? ( >=dev-db/postgresql-8.4:= )
	qhull? ( media-libs/qhull:= )
	spatialite? ( dev-db/spatialite )
	sqlite? (
			>=dev-db/sqlite-3.31:3
			dev-libs/libpcre2:=
	)
	webp? ( media-libs/libwebp:= )
	xls? ( dev-libs/freexl )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="${COMMON_DEPEND}
	exprtk? ( dev-cpp/exprtk )
	test? ( dev-cpp/gtest )
"
BDEPEND="
	virtual/pkgconfig
	java? (
		>=dev-java/ant-1.10.14-r3:0
		dev-lang/swig
	)
	python? (
		${DISTUTILS_DEPS}
		dev-lang/swig
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			test? (
				  dev-python/filelock[${PYTHON_USEDEP}]
				  dev-python/jsonschema[${PYTHON_USEDEP}]
				  dev-python/lxml[${PYTHON_USEDEP}]
				  >=dev-python/pytest-6.0.0[${PYTHON_USEDEP}]
				  dev-python/pytest-env[${PYTHON_USEDEP}]
				  dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
				  parquet? ( dev-python/pyarrow[parquet,${PYTHON_USEDEP}] )
			)
		')
	)
"

QA_CONFIG_IMPL_DECL_SKIP=(
	_wstat64 # Windows LFS
)

EPYTEST_PLUGINS=( pytest-env )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
# distutils_enable_tests unconditionally touches BDEPEND

PATCHES=(
	"${FILESDIR}"/gdal-3.11.3-x86.patch
	"${FILESDIR}"/gdal-3.11.3-java-no-strict-aliasing.patch
	"${FILESDIR}"/gdal-3.11.3-fix-completions.patch
)

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	if use test ; then
		mv "${WORKDIR}"/gdalautotest-${PV} "${S}"/autotest || die
	fi
	java-pkg-opt-2_src_prepare
	cmake_src_prepare
}

python_configure_all() {
	local -x BUILD_DIR="${S}_python"
	# Generate required files with cmake and then use distutils-r1 to generate wheels
	# https://github.com/OSGeo/gdal/issues/9965#issuecomment-2159222393
	mycmakeargs+=( -DBUILD_PYTHON_BINDINGS=ON )
	cmake_src_configure
	cmake_build python_generated_files
	cmake_build generate_gdal_version_h
	sed -E -e "/(library_dirs|include_dirs) =/ { s|${BUILD_DIR}|${cmake_build_dir}| } " \
		-i "${BUILD_DIR}/swig/python/setup.py" || die
}

src_configure() {
	# sanity check subslot to give a friendly reminder to would-be drive by bumpers
	local detected_soversion
	detected_soversion="$(sed -n -e 's/set(GDAL_SOVERSION \(.*\))/\1/p' gdal.cmake)"
	if [[ "${SLOT#0/}" != "${detected_soversion}" ]]; then
		die "Subslot ${SLOT#0/} doesn't match upstream specified set(GDAL_SOVERSION ${detected_soversion}) in gdal.cmake."
	fi

	# ODR violations
	filter-lto

	local mycmakeargs=(
		# https://gdal.org/en/stable/development/building_from_source.html

		-DBUILD_APPS=$(usex tools)
		-DBUILD_TESTING=$(usex test)
		-DENABLE_GNM=ON
		-DENABLE_IPO=OFF
		-DENABLE_PAM=ON # Persistent Auxiliary Metadata (not Pluggable Authentication Modules!)
		-DOGR_ENABLE_DRIVER_SQLITE=$(usex sqlite)
		-DGDAL_ENABLE_PLUGINS=OFF
		-DGDAL_ENABLE_PLUGINS_NO_DEPS=OFF
		-DGDAL_BUILD_OPTIONAL_DRIVERS=ON
		-DOGR_BUILD_OPTIONAL_DRIVERS=ON
		-DGDAL_USE_EXTERNAL_LIBS=ON
		-DGDAL_USE_INTERNAL_LIBS=OFF
		-DUSE_CCACHE=OFF
		-DUSE_PRECOMPILED_HEADERS=OFF

		# bug #844874 and bug #845150
		-DCMAKE_INSTALL_INCLUDEDIR="include/gdal"

		-DGDAL_FIND_PACKAGE_PROJ_MODE=CONFIG

		# Options here are generally off because of one of:
		# - Not yet packaged dependencies
		#
		# - Off for autotools build and didn't want more churn by
		#   enabling during port to CMake. Feel free to request them
		#   being turned on if useful for you.
		#
		# See cmake/helpers/CheckDependentLibraries.cmake for options
		# *_*_package(Option) -> GDAL_USE_OPTION
		-DGDAL_USE_ADBCDRIVERMANAGER=OFF
		-DGDAL_USE_ARCHIVE=$(usex archive)
		-DGDAL_USE_ARMADILLO=$(usex armadillo)
		-DGDAL_USE_AVIF=$(usex avif)
		-DGDAL_USE_ARROW=$(usex parquet)
		-DGDAL_USE_BASISU=OFF
		-DGDAL_USE_BLOSC=$(usex blosc)
		-DGDAL_USE_BRUNSLI=OFF
		-DGDAL_USE_CRNLIB=OFF
		-DGDAL_USE_CFITSIO=$(usex fits)
		-DGDAL_USE_CURL=$(usex curl)
		-DGDAL_USE_CRYPTOPP=$(usex cryptopp)
		-DGDAL_USE_DEFLATE=$(usex libdeflate) # complements zlib
		-DGDAL_USE_ECW=OFF
		-DGDAL_USE_EXPAT=ON
		-DGDAL_USE_EXPRTK=$(usex exprtk)
		-DGDAL_USE_FILEGDB=OFF
		-DGDAL_USE_FREEXL=$(usex xls)
		-DGDAL_USE_FYBA=OFF
		-DGDAL_USE_GEOTIFF=ON
		-DGDAL_USE_GEOS=$(usex geos)
		-DGDAL_USE_GIF=$(usex gif)
		-DGDAL_USE_GTA=OFF
		-DGDAL_USE_HEIF=$(usex heif)
		-DGDAL_USE_HDF4=OFF
		-DGDAL_USE_HDF5=$(usex hdf5)
		-DGDAL_USE_HDFS=OFF
		-DGDAL_USE_ICONV=ON # TODO dep
		-DGDAL_USE_IDB=OFF

		# Enable internal implementation so that tests pass with the use disabled
		-DGDAL_USE_JPEG=$(usex jpeg)
		-DGDAL_USE_JPEG_INTERNAL=$(usex !jpeg)

		# https://gdal.org/build_hints.html#jpeg12
		# Independent of whether using system libjpeg
		-DGDAL_USE_JPEG12_INTERNAL=ON

		-DGDAL_USE_JSONC=ON
		-DGDAL_USE_JXL=$(usex jpegxl)
		-DGDAL_USE_JXL_THREADS=$(usex jpegxl)
		-DGDAL_USE_KDU=OFF
		-DGDAL_USE_KEA=OFF
		-DGDAL_USE_LERC=$(usex lerc)
		-DGDAL_USE_LIBAEC=$(usex libaec)
		-DGDAL_USE_LIBKML=OFF
		-DGDAL_USE_LIBLZMA=$(usex lzma)
		-DGDAL_USE_LIBQB3=OFF
		-DGDAL_USE_LIBXML2=ON
		-DGDAL_USE_LZ4=$(usex lz4) # FIXME
		-DGDAL_USE_MONGOCXX=$(usex mongodb)
		-DGDAL_USE_MRSID=OFF
		-DGDAL_USE_MSSQL_NCLI=OFF
		-DGDAL_USE_MSSQL_ODBC=OFF
		-DGDAL_USE_MUPARSER=$(usex muparser)
		-DGDAL_USE_MYSQL=$(usex mysql)
		-DGDAL_USE_NETCDF=$(usex netcdf)
		-DGDAL_USE_ODBC=$(usex odbc)
		-DGDAL_USE_ODBCCPP=OFF

		# unpackaged
		-DGDAL_USE_OPENCAD=OFF
		-DGDAL_USE_OPENCAD_INTERNAL=ON

		-DGDAL_USE_OPENDRIVE=OFF
		-DGDAL_USE_OPENEXR=$(usex openexr)
		-DGDAL_USE_OPENJPEG=$(usex jpeg2k)
		-DGDAL_USE_OPENSSL=ON
		-DGDAL_USE_ORACLE=$(usex oracle)
		-DGDAL_USE_PARQUET=$(usex parquet)
		-DGDAL_USE_PCRE2=ON
		-DGDAL_USE_PDFIUM=OFF

		# Enable internal implementation so that tests pass with the use disabled
		-DGDAL_USE_PNG=$(usex png)
		-DGDAL_USE_PNG_INTERNAL=$(usex !png)

		-DGDAL_USE_PODOFO=OFF
		-DGDAL_USE_POPPLER=$(usex pdf)
		-DGDAL_USE_POSTGRESQL=$(usex postgres)
		-DGDAL_USE_QHULL=$(usex qhull)
		-DGDAL_USE_RASTERLITE2=OFF

		# upstream recommends using the internal implementation
		# bug #935567
		-DGDAL_USE_SHAPELIB=OFF
		-DGDAL_USE_SHAPELIB_INTERNAL=ON

		-DGDAL_USE_SPATIALITE=$(usex spatialite)
		-DGDAL_USE_SQLITE3=$(usex sqlite)
		-DGDAL_USE_SFCGAL=OFF
		-DGDAL_USE_TEIGHA=OFF
		-DGDAL_USE_TIFF=ON
		-DGDAL_USE_WEBP=$(usex webp)
		-DGDAL_USE_XERCESC=$(usex gml)
		-DGDAL_USE_ZLIB=ON
		-DGDAL_USE_ZSTD=$(usex zstd)

		# Bindings
		-DBUILD_PYTHON_BINDINGS=OFF # handled separately
		-DBUILD_JAVA_BINDINGS=$(usex java)
		# bug #845369
		-DBUILD_CSHARP_BINDINGS=OFF

		# Handled differently from x86
		# First checks if the platform supports neon and if it supports the option will be available
		# See SSE2NEON_COMPILES in CMakeLists.txt and gdal.cmake
		-DGDAL_ENABLE_ARM_NEON_OPTIMIZATIONS=$(usex cpu_flags_arm_neon)
	)

	if use x86 || use amd64 ; then
		mycmakeargs+=(
			# Check work/gdal-3.5.0_build/CMakeCache.txt after configure
			# and https://github.com/OSGeo/gdal/blob/master/cmake/helpers/CheckCompilerMachineOption.cmake#L71
			# Commented out: not (yet?) implemented upstream.
			#
			# check_compiler_machine_option(flag <instruction set>) -> -Dtest_<instruction set>
			-Dtest_avx=$(usex cpu_flags_x86_avx)
			-Dtest_avx2=$(usex cpu_flags_x86_avx2)
			-Dtest_sse=$(usex cpu_flags_x86_sse)
			-Dtest_sse2=$(usex cpu_flags_x86_sse2)
			#-Dtest_sse3=$(usex cpu_flags_x86_sse3)
			-Dtest_sse4.1=$(usex cpu_flags_x86_sse4_1)
			#-Dtest_sse4.2=$(usex cpu_flags_x86_sse4_2)
			#-Dtest_sse4a=$(usex cpu_flags_x86_sse4a)
			-Dtest_ssse3=$(usex cpu_flags_x86_ssse3)
			#-Dtest_fma4=$(usex cpu_flags_x86_fma4)
			#-Dtest_xop=$(usex cpu_flags_x86_xop)
		)
	fi

	if use test ; then
		mycmakeargs+=( -DUSE_EXTERNAL_GTEST=ON )
	fi

	cmake_src_configure

	local cmake_build_dir="${BUILD_DIR}"
	use python && distutils-r1_src_configure
}

python_compile() {
	pushd "${S}_python/swig/python" >/dev/null || die
	distutils-r1_python_compile
	popd >/dev/null ||  die
}

src_compile() {
	cmake_src_compile

	use python && distutils-r1_src_compile
}

python_test() {
	local -x GDAL_DATA="${S}/data"

	# note: testpaths in pytest.ini will fight EPYTEST_IGNORE
	EPYTEST_IGNORE=(
		# network-sandbox and deselecting tests turns into whac-a-mole with their interdependencies
		"gcore/vsis3.py"
	)

	use !muparser && EPYTEST_IGNORE+=( "gdrivers/vrtpansharpen.py" )
	use !pdf && EPYTEST_IGNORE+=( "gdrivers/pdf.py" )

	EPYTEST_DESELECT=(
		# network-sandbox
		"gcore/tiff_read.py::test_tiff_read_strace_check"
		"gcore/vsioss.py::test_vsioss_6"
		"gdrivers/gdalhttp.py::test_http_ssl_verifystatus"
		"gdrivers/jp2openjpeg.py::test_jp2openjpeg_45"
		"gdrivers/wms.py::test_wms_8"
		"ogr/ogr_csv.py::test_ogr_csv_schema_override"
		"ogr/ogr_geojson.py::test_ogr_geojson_schema_override"
		"ogr/ogr_gml.py::test_ogr_gml_type_override"
		"ogr/ogr_gmlas.py::test_ogr_gmlas_billion_laugh"
		"ogr/ogr_parquet.py::test_ogr_parquet_coordinate_epoch"
		"ogr/ogr_parquet.py::test_ogr_parquet_crs_identification_on_write"
		"ogr/ogr_parquet.py::test_ogr_parquet_edges"
		"ogr/ogr_parquet.py::test_ogr_parquet_geoarrow"
		"ogr/ogr_parquet.py::test_ogr_parquet_geometry_types"
		"ogr/ogr_parquet.py::test_ogr_parquet_polygon_orientation"
		"ogr/ogr_sqlite.py::test_ogr_sqlite_schema_override"
		"pyscripts/test_validate_geoparquet.py::test_validate_geoparquet_ok"
		"utilities/test_gdalinfo_lib.py::test_gdalinfo_lib_2"
		"utilities/test_gdalinfo_lib.py::test_gdalinfo_lib_5"
		"utilities/test_gdalinfo_lib.py::test_gdalinfo_lib_json_color_table_and_rat"
		"utilities/test_ogrinfo_lib.py::test_ogrinfo_lib_extent3D"
		"utilities/test_ogrinfo_lib.py::test_ogrinfo_lib_json_relationships"
		"utilities/test_ogrinfo_lib.py::test_ogrinfo_lib_json_validate"

		# sandbox interferes with strace?
		"gcore/basic_test.py::test_basic_test_strace_non_existing_file"

		# Breaks due to other deselects.
		"ogr/ogr_gpkg.py::test_ogr_gpkg_immutable"
		"ogr/ogr_gpkg.py::test_ogr_gpkg_nolock"
		"ogr/ogr_parquet.py::test_ogr_parquet_read_large_binary_or_string_for_geometry"
		"ogr/ogr_parquet.py::test_ogr_parquet_write_arrow_rewind_polygon"
		"ogr/ogr_parquet.py::test_ogr_parquet_bbox_float32"
		"ogr/ogr_sqlite.py::test_ogr_sqlite_34"

		# USE="pdf" poppler 25.07?
		# assert 8191 in (7926, 8177, 8174, 8165, 8172, 8193)
		"gdrivers/pdf.py::test_pdf_extra_rasters[POPPLER]"
	)

	if use !armadillo; then
		EPYTEST_DESELECT+=(
			# AssertionError: (1634, (3456541.352648813, 5640759.820845713, 0.0))
			"gcore/transformer.py::test_transformer_tps_precision"
		)
	fi

	if use !sqlite; then
		EPYTEST_DESELECT+=(
			# implicit sqlite requirement for the test (or the wms (curl) driver)?
			"gdrivers/ogcapi.py::test_ogr_ogcapi_vector_tiles"
			# expects sqlite being enabled in a warning message
			"utilities/test_gdalalg_vector_rasterize.py::test_gdalalg_vector_rasterize"
		)
	fi

	pushd "${S}_python/autotest" >/dev/null || die
	# https://github.com/OSGeo/gdal/tree/v3.11.3/autotest#gdals-tests-are-not-independent
	# So run directories separately with reruns to maximise chances without excluding every test
	#
	# See pytest_dirs in autotest/CMakeLists.txt.
	# benchmark excluded on purpose as it uses pytest-benchmark
	# gdrivers excluded as its especially flaky with excluding tests
	# gnm excluded as you need to exclude 99% of it leaving only one or two tests
	local failures=()
	for pytest_dir in alg gcore gdrivers ogr osr pyscripts utilities; do
		nonfatal epytest ${pytest_dir}
		[[ ${?} != 0 ]] && failures+=( ${pytest_dir} )
	done
	popd >/dev/null ||  die

	if [[ ${#failures} -gt 0 ]]; then
		die "pytest failures: ${failures[@]}"
	fi
}

src_test() {
	local -x GDAL_RUN_SLOW_TESTS=0
	local -x GDAL_DOWNLOAD_TEST_DATA=0 # tests relying on downloaded data **may** be skipped

	cmake_src_test

	local -x PATH="${BUILD_DIR}/apps:${PATH}"
	local -x LD_LIBRARY_PATH="${BUILD_DIR}:${LD_LIBRARY_PATH}"
	use python && distutils-r1_src_test
}

python_install() {
	pushd "${S}_python/swig/python" >/dev/null || die
	distutils-r1_python_install
	popd >/dev/null ||  die
}

src_install() {
	cmake_src_install

	if use java; then
		# Move the native library into the proper place for Gentoo.  The
		# library in ${D} has already had its RPATH fixed, so we use it
		# rather than ${BUILD_DIR}/swig/java/libgdalalljni.so.
		java-pkg_doso "${D}/usr/$(get_libdir)/jni/libgdalalljni.so"
		rm -rf "${ED}/usr/$(get_libdir)/jni" || die
	fi

	use python && distutils-r1_src_install
}

pkg_postinst() {
	elog "Check available image and data formats after building with"
	if use tools; then
		elog "gdal info --formats"
	else
		elog "gdal-config --formats"
	fi

	if use java; then
		elog
		elog "To use the Java bindings, you need to pass the following to java:"
		elog "    -Djava.library.path=$(java-config -i gdal)"
	fi
}
