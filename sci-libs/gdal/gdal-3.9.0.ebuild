# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake java-pkg-opt-2 python-single-r1

DESCRIPTION="Translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="https://gdal.org/"
SRC_URI="https://download.osgeo.org/${PN}/${PV}/${P}.tar.xz"
SRC_URI+=" test? ( https://download.osgeo.org/${PN}/${PV}/${PN}autotest-${PV}.tar.gz )"

LICENSE="BSD Info-ZIP MIT"
SLOT="0/34" # subslot is libgdal.so.<SONAME>
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="armadillo +curl cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse4_1 cpu_flags_x86_ssse3 doc fits geos gif gml hdf5 heif java jpeg jpeg2k lzma mysql netcdf odbc ogdi opencl oracle parquet pdf png postgres python spatialite sqlite test webp xls zstd"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	spatialite? ( sqlite )
	test? ( ${PYTHON_REQUIRED_USE} )
"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	java? (
		>=dev-java/ant-1.10.14-r3:0
		dev-lang/swig
	)
	python? (
		dev-lang/swig
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_USEDEP}]
		')
	)
	test? (
		${PYTHON_DEPS}
		dev-cpp/gtest
	)
"
DEPEND="
	dev-libs/expat
	dev-libs/json-c:=
	dev-libs/libpcre2
	dev-libs/libxml2:2
	dev-libs/openssl:=
	media-libs/tiff
	>=sci-libs/libgeotiff-1.5.1-r1:=
	>=sci-libs/proj-6.0.0:=
	sys-libs/zlib[minizip(+)]
	armadillo? ( sci-libs/armadillo:=[lapack] )
	curl? ( net-misc/curl )
	fits? ( sci-libs/cfitsio:= )
	geos? ( >=sci-libs/geos-3.8.0 )
	gif? ( media-libs/giflib:= )
	gml? ( >=dev-libs/xerces-c-3.1 )
	heif? ( media-libs/libheif:= )
	hdf5? ( >=sci-libs/hdf5-1.6.4:=[cxx,szip] )
	java? (
		>=virtual/jdk-1.8:*[-headless-awt]
	)
	jpeg? ( media-libs/libjpeg-turbo:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	lzma? ( || (
		app-arch/xz-utils
		app-arch/lzma
	) )
	mysql? ( virtual/mysql )
	netcdf? ( sci-libs/netcdf:= )
	odbc? ( dev-db/unixODBC )
	ogdi? ( >=sci-libs/ogdi-4.1.0-r1 )
	opencl? ( virtual/opencl )
	oracle? ( dev-db/oracle-instantclient:= )
	parquet? ( dev-libs/apache-arrow:=[parquet] )
	pdf? ( app-text/poppler:= )
	png? ( media-libs/libpng:= )
	postgres? ( >=dev-db/postgresql-8.4:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
	)
	spatialite? ( dev-db/spatialite )
	sqlite? ( dev-db/sqlite:3 )
	webp? ( media-libs/libwebp:= )
	xls? ( dev-libs/freexl )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="
	${DEPEND}
	java? ( >=virtual/jre-1.8:* )
"

QA_CONFIG_IMPL_DECL_SKIP=(
	_wstat64 # Windows LFS
)

PATCHES=(
	"${FILESDIR}"/${PN}-3.6.4-abseil-cpp-20230125.2-c++17.patch
)

pkg_setup() {
	if use python || use test ; then
		python-single-r1_pkg_setup
	fi

	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if use test ; then
		mv "${WORKDIR}"/gdalautotest-${PV} "${S}"/autotest || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_IPO=OFF
		-DGDAL_USE_EXTERNAL_LIBS=ON
		-DGDAL_USE_INTERNAL_LIBS=OFF
		-DBUILD_TESTING=$(usex test)

		# bug #844874 and bug #845150
		-DCMAKE_INSTALL_INCLUDEDIR="include/gdal"

		# Options here are generally off because of one of:
		# - Not yet packaged dependencies
		#
		# - Off for autotools build and didn't want more churn by
		#   enabling during port to CMake. Feel free to request them
		#   being turned on if useful for you.
		-DGDAL_USE_ARMADILLO=$(usex armadillo)
		-DGDAL_USE_ARROW=OFF
		-DGDAL_USE_BLOSC=OFF
		-DGDAL_USE_BRUNSLI=OFF
		-DGDAL_USE_CRNLIB=OFF
		-DGDAL_USE_CFITSIO=$(usex fits)
		-DGDAL_USE_CURL=$(usex curl)
		-DGDAL_USE_CRYPTOPP=OFF
		-DGDAL_USE_DEFLATE=OFF
		-DGDAL_USE_ECW=OFF
		-DGDAL_USE_EXPAT=ON
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
		-DGDAL_USE_JPEG=$(usex jpeg)

		# https://gdal.org/build_hints.html#jpeg12
		# Independent of whether using system libjpeg
		-DGDAL_USE_JPEG12_INTERNAL=ON

		-DGDAL_USE_JSONC=ON
		-DGDAL_USE_JXL=OFF
		-DGDAL_USE_KDU=OFF
		-DGDAL_USE_KEA=OFF
		-DGDAL_USE_LERC=OFF
		-DGDAL_USE_LIBKML=OFF
		-DGDAL_USE_LIBLZMA=$(usex lzma)
		-DGDAL_USE_LIBXML2=ON
		-DGDAL_USE_LURATECH=OFF
		-DGDAL_USE_LZ4=OFF
		-DGDAL_USE_MONGOCXX=OFF
		-DGDAL_USE_MRSID=OFF
		-DGDAL_USE_MSSQL_NCLI=OFF
		-DGDAL_USE_MSSQL_ODBC=OFF
		-DGDAL_USE_MYSQL=$(usex mysql)
		-DGDAL_USE_NETCDF=$(usex netcdf)
		-DGDAL_USE_ODBC=$(usex odbc)
		-DGDAL_USE_ODBCCPP=OFF
		-DGDAL_USE_OGDI=$(usex ogdi)
		-DGDAL_USE_OPENCAD=OFF
		-DGDAL_USE_OPENCL=$(usex opencl)
		-DGDAL_USE_OPENEXR=OFF
		-DGDAL_USE_OPENJPEG=$(usex jpeg2k)
		-DGDAL_USE_OPENSSL=ON
		-DGDAL_USE_ORACLE=$(usex oracle)
		-DGDAL_USE_PARQUET=$(usex parquet)
		-DGDAL_USE_PCRE2=ON
		-DGDAL_USE_PDFIUM=OFF
		-DGDAL_USE_PNG=$(usex png)
		-DGDAL_USE_PODOFO=OFF
		-DGDAL_USE_POPPLER=$(usex pdf)
		-DGDAL_USE_POSTGRESQL=$(usex postgres)
		-DGDAL_USE_QHULL=OFF
		-DGDAL_USE_RASTERLITE2=OFF
		-DGDAL_USE_RDB=OFF
		-DGDAL_USE_SPATIALITE=$(usex spatialite)
		-DGDAL_USE_SQLITE3=$(usex sqlite)
		-DGDAL_USE_SFCGAL=OFF
		-DGDAL_USE_TEIGHA=OFF
		-DGDAL_USE_TIFF=ON
		-DGDAL_USE_TILEDB=OFF
		-DGDAL_USE_WEBP=$(usex webp)
		-DGDAL_USE_XERCESC=$(usex gml)
		-DGDAL_USE_ZLIB=ON
		-DGDAL_USE_ZSTD=$(usex zstd)

		# Bindings
		-DBUILD_PYTHON_BINDINGS=$(usex python)
		-DBUILD_JAVA_BINDINGS=$(usex java)
		# bug #845369
		-DBUILD_CSHARP_BINDINGS=OFF

		# Check work/gdal-3.5.0_build/CMakeCache.txt after configure
		# and https://github.com/OSGeo/gdal/blob/master/cmake/helpers/CheckCompilerMachineOption.cmake#L71
		# Commented out: not (yet?) implemented upstream.
		# Also, arm64 stuff is a TODO upstream, but not there (yet?)
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

	if use test ; then
		mycmakeargs+=( -DUSE_EXTERNAL_GTEST=ON )
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile doc
}

src_test() {
	export GDAL_RUN_SLOW_TESTS=0
	export GDAL_DOWNLOAD_TEST_DATA=0

	# Two test suites:
	# 1. autotests (much larger, uses pytest)
	# 2. Small set of fuzzing tests (no download needed)

	# Missing file for test-unit?
	cmake_src_test -E "(test-unit)"
}

src_install() {
	cmake_src_install
	use python && python_optimize

	if use java; then
		# Move the native library into the proper place for Gentoo.  The
		# library in ${D} has already had its RPATH fixed, so we use it
		# rather than ${BUILD_DIR}/swig/java/libgdalalljni.so.
		java-pkg_doso "${D}/usr/$(get_libdir)/jni/libgdalalljni.so"
		rm -rf "${ED}/usr/$(get_libdir)/jni" || die
	fi

	# TODO: install docs?
}

pkg_postinst() {
	elog "Check available image and data formats after building with"
	elog "gdalinfo and ogrinfo (using the --formats switch)."

	if use java; then
		elog
		elog "To use the Java bindings, you need to pass the following to java:"
		elog "    -Djava.library.path=$(java-config -i gdal)"
	fi
}
