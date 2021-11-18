# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GENTOO_DEPEND_ON_PERL="no"
PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_OPTIONAL=1
inherit autotools bash-completion-r1 distutils-r1 flag-o-matic java-pkg-opt-2 perl-module toolchain-funcs

DESCRIPTION="Translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="https://gdal.org/"
SRC_URI="https://download.osgeo.org/${PN}/${PV}/${P}.tar.gz"

SLOT="0/3.2"
LICENSE="BSD Info-ZIP MIT"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="armadillo +aux-xml curl cpu_flags_x86_avx cpu_flags_x86_sse cpu_flags_x86_ssse3 debug doc fits geos gif gml hdf5 java jpeg jpeg2k lzma mdb mysql netcdf odbc ogdi opencl oracle pdf perl png postgres python spatialite sqlite threads webp xls zstd"

REQUIRED_USE="
	mdb? ( java )
	python? ( ${PYTHON_REQUIRED_USE} )
	spatialite? ( sqlite )
"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	java? (
		dev-java/ant-core
		dev-lang/swig:0
		>=virtual/jdk-1.7:*
	)
	perl? ( dev-lang/swig:0 )
	python? (
		dev-lang/swig:0
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-libs/expat
	dev-libs/json-c:=
	dev-libs/libpcre
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
	hdf5? ( >=sci-libs/hdf5-1.6.4:=[szip] )
	jpeg? ( virtual/jpeg:0= )
	jpeg2k? ( media-libs/openjpeg:2= )
	lzma? ( || (
		app-arch/xz-utils
		app-arch/lzma
	) )
	mdb? ( dev-java/jackcess:1 )
	mysql? ( virtual/mysql )
	netcdf? ( sci-libs/netcdf:= )
	odbc? ( dev-db/unixODBC )
	ogdi? ( sci-libs/ogdi )
	opencl? ( virtual/opencl )
	oracle? ( dev-db/oracle-instantclient:= )
	pdf? ( app-text/poppler:= )
	perl? ( dev-lang/perl:= )
	png? ( media-libs/libpng:0= )
	postgres? ( >=dev-db/postgresql-8.4:= )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	spatialite? ( dev-db/spatialite )
	sqlite? ( dev-db/sqlite:3 )
	webp? ( media-libs/libwebp:= )
	xls? ( dev-libs/freexl )
	zstd? ( app-arch/zstd:= )
"
RDEPEND="${DEPEND}
	java? ( >=virtual/jre-1.7:* )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.3-soname.patch"
	"${FILESDIR}/${PN}-2.3.0-curl.patch" # bug 659840
	"${FILESDIR}/${PN}-3.2.1-libdir.patch"
)

src_prepare() {
	default

	# Drop a --prefix hack in the upstream build system
	# We don't want the line at all, so let's just drop it rather than
	# trying to put in the right libdir value.
	# bug #696106
	sed -e '/\$ADD_PREFIX\/lib/d' \
		-i configure.ac || die

	sed -e "s: /usr/: \"${EPREFIX}\"/usr/:g" \
		-i configure.ac || die

	sed -e 's:^ar:$(AR):g' \
		-i ogr/ogrsf_frmts/sdts/install-libs.sh || die

	# SWIG: Use of the include path to find the input file is deprecated and will not work with ccache.
	sed -e "s: gdal_array.i: ../include/gdal_array.i:" \
		-i swig/python/GNUmakefile || die "sed python makefile failed"

	# autoconf 2.70+
	# bug #775209
	config_rpath_update .

	eautoreconf
}

src_configure() {
	local myconf=(
		# charls - not packaged in Gentoo ebuild repository
		# kakadu, mrsid jp2mrsid - another jpeg2k stuff, ignore
		# bsb - legal issues
		# ingres - same story as oracle oci
		# jasper - disabled because unmaintained and vulnerable; openjpeg will be used as JPEG-2000 provider instead
		# podofo - we use poppler instead they are exclusive for each other
		# tiff is a hard dep
		--includedir="${EPREFIX}"/usr/include/${PN}
		--disable-lto
		--disable-static
		--disable-driver-bsb
		--disable-driver-mrf
		--disable-pdf-plugin
		--enable-shared
		--enable-driver-grib
		--with-bash-completion="$(get_bashcompdir)"
		--with-cpp14
		--with-crypto
		--with-cryptopp=no
		--with-expat
		--with-geotiff
		--with-gnm
		--with-hide-internal-symbols
		--with-libjson-c="${EPREFIX}"/usr
		--with-libtiff
		--with-libtool
		--with-libz="${EPREFIX}"/usr
		--without-charls
		--without-dods-root
		--without-ecw
		--without-epsilon
		--without-fgdb
		--without-fme
		--without-gta
		--without-grass
		--without-hdf4
		--without-idb
		--without-ingres
		--without-jasper
		--without-jp2lura
		--without-jp2mrsid
		--without-kakadu
		--without-kea
		--without-libkml
		--without-mongocxx
		--without-mrsid
		--without-mrsid_lidar
		--without-msg
		--without-rasdaman
		--without-rasterlite2
		--without-pcraster
		--without-pdfium
		--without-perl
		--without-podofo
		--without-python
		--without-qhull
		--without-sfcgal
		--without-sosi
		--without-teigha
		$(use_enable debug)
		$(use_with armadillo)
		$(use_with aux-xml pam)
		$(use_with curl)
		$(use_with cpu_flags_x86_avx avx)
		$(use_with cpu_flags_x86_sse sse)
		$(use_with cpu_flags_x86_ssse3 ssse3)
		$(use_with fits cfitsio)
		$(use_with geos)
		$(use_with gif)
		$(use_with gml xerces)
		$(use_with hdf5)
		$(use_with jpeg pcidsk) # pcidsk is internal, because there is no such library released developer by gdal
		$(use_with jpeg)
		$(use_with jpeg2k openjpeg)
		$(use_with lzma liblzma)
		$(use_with mysql mysql "${EPREFIX}"/usr/bin/mysql_config)
		$(use_with netcdf)
		$(use_with oracle oci)
		$(use_with odbc)
		$(use_with ogdi ogdi "${EPREFIX}"/usr)
		$(use_with opencl)
		$(use_with pdf poppler)
		$(use_with png)
		$(use_with postgres pg)
		$(use_with spatialite)
		$(use_with sqlite sqlite3 "${EPREFIX}"/usr)
		$(use_with threads)
		$(use_with webp)
		$(use_with xls freexl)
		$(use_with zstd)
	)

	tc-export AR RANLIB

	if use java; then
		myconf+=(
			--with-java=$(java-config --jdk-home 2>/dev/null)
			--with-jvm-lib=dlopen
			$(use_with mdb)
		)
	else
		myconf+=( --without-java --without-mdb )
	fi

	if use sqlite; then
		append-libs -lsqlite3
	fi

	# bug #632660
	if use ogdi; then
		append-cflags $($(tc-getPKG_CONFIG) --cflags libtirpc)
		append-cxxflags $($(tc-getPKG_CONFIG) --cflags libtirpc)
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	# mysql-config puts this in (and boy is it a PITA to get it out)
	if use mysql; then
		sed -e "s: -rdynamic : :" \
			-i GDALmake.opt || die "sed LIBS failed"
	fi
}

src_compile() {
	if use perl; then
		rm "${S}"/swig/perl/*_wrap.cpp || die
		emake -C "${S}"/swig/perl generate
	fi

	# gdal-config needed before generating Python bindings
	default

	if use java; then
		pushd "${S}"/swig/java > /dev/null || die
		emake
		popd > /dev/null || die
	fi

	if use perl; then
		pushd "${S}"/swig/perl > /dev/null || die
		perl-module_src_configure
		perl-module_src_compile
		popd > /dev/null || die
	fi

	if use python; then
		rm -f "${S}"/swig/python/*_wrap.cpp || die
		emake -C "${S}"/swig/python generate
		pushd "${S}"/swig/python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi

	use doc && emake docs
}

src_install() {
	local DOCS=( NEWS )
	use doc && local HTML_DOCS=( html/. )

	default

	use java && java-pkg_dojar "${S}"/swig/java/gdal.jar

	if use perl; then
		pushd "${S}"/swig/perl > /dev/null || die
		myinst=( DESTDIR="${D}" )
		perl-module_src_install
		popd > /dev/null || die
		perl_delete_localpod
	fi

	if use python; then
		# Don't clash with gdal's docs
		unset DOCS HTML_DOCS

		pushd "${S}"/swig/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die

		newdoc swig/python/README.rst README-python.rst

		insinto /usr/share/${PN}/samples
		doins -r swig/python/samples/.
	fi

	doman "${S}"/man/man*/*
	find "${ED}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	elog "Check available image and data formats after building with"
	elog "gdalinfo and ogrinfo (using the --formats switch)."
}
