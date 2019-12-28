# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GENTOO_DEPEND_ON_PERL="no"
PYTHON_COMPAT=( python3_{5,6,7,8} )
DISTUTILS_OPTIONAL=1
inherit autotools perl-module distutils-r1 flag-o-matic java-pkg-opt-2 toolchain-funcs

DESCRIPTION="Translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="https://gdal.org/"
SRC_URI="https://download.osgeo.org/${PN}/${PV}/${P}.tar.gz"

SLOT="0/2.3"
LICENSE="BSD Info-ZIP MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="armadillo +aux-xml curl debug doc fits geos gif gml hdf5 java jpeg jpeg2k lzma mdb mysql netcdf odbc ogdi opencl oracle pdf perl png postgres python spatialite sqlite threads webp xls zstd"

REQUIRED_USE="
	mdb? ( java )
	python? ( ${PYTHON_REQUIRED_USE} )
	spatialite? ( sqlite )
"

BDEPEND="
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.7:* )
	perl? ( dev-lang/swig:0 )
	python? (
		dev-lang/swig:0
		dev-python/setuptools[${PYTHON_USEDEP}]
	)"

DEPEND="
	dev-libs/expat
	dev-libs/json-c:=
	dev-libs/libpcre
	dev-libs/libxml2:=
	media-libs/tiff:0=
	sci-libs/libgeotiff:=
	sys-libs/zlib:=[minizip(+)]
	armadillo? ( sci-libs/armadillo:=[lapack] )
	curl? ( net-misc/curl )
	fits? ( sci-libs/cfitsio:= )
	geos? ( >=sci-libs/geos-2.2.1 )
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
	zstd? ( app-arch/zstd:= )"

RDEPEND="${DEPEND}
	java? ( >=virtual/jre-1.7:* )"

PATCHES=(
	"${FILESDIR}/${PN}-2.2.3-soname.patch"
	"${FILESDIR}/${PN}-2.2.3-bashcomp-path.patch" # bug 641866
	"${FILESDIR}/${PN}-2.3.0-curl.patch" # bug 659840
	"${FILESDIR}/${P}-poppler-0.75.patch"
	"${FILESDIR}/${P}-poppler-0.76.patch"
	"${FILESDIR}/${P}-swig-4.patch" # bug 689110
	"${FILESDIR}/${P}-poppler-0.82.patch"
	"${FILESDIR}"/${P}-poppler-0.83-{1,2}.patch # bug 703790
)

src_prepare() {
	# fix datadir and docdir placement
	sed -e "s:@datadir@:@datadir@/gdal:" \
		-e "s:@exec_prefix@/doc:@exec_prefix@/share/doc/${PF}/html:g" \
		-i "${S}"/GDALmake.opt.in || die

	# the second sed expression should fix bug 371075
	sed -e "s:setup.py install:setup.py install --root=\$(DESTDIR):" \
		-e "s:--prefix=\$(DESTDIR):--prefix=:" \
		-i "${S}"/swig/python/GNUmakefile || die

	# Fix spatialite/sqlite include issue
	sed -e 's:spatialite/sqlite3.h:sqlite3.h:g' \
		-i ogr/ogrsf_frmts/sqlite/ogr_sqlite.h || die

	# Fix freexl configure check
	sed -e 's:FREEXL_LIBS=missing):FREEXL_LIBS=missing,-lm):g' \
		-i configure.ac || die

	sed -e "s: /usr/: \"${EPREFIX}\"/usr/:g" \
		-i configure.ac || die

	sed -e 's:^ar:$(AR):g' \
		-i ogr/ogrsf_frmts/sdts/install-libs.sh || die

	# updated for newer swig (must specify the path to input files)
	sed -e "s: gdal_array.i: ../include/gdal_array.i:" \
		-e "s:\$(DESTDIR)\$(prefix):\$(DESTDIR)\$(INST_PREFIX):g" \
		-i swig/python/GNUmakefile || die "sed python makefile failed"
	sed -e "s:library_dirs = :library_dirs = /usr/$(get_libdir):g" \
		-i swig/python/setup.cfg || die "sed python setup.cfg failed"

	default

	eautoreconf
}

src_configure() {
	# bug 619148
	append-cxxflags -std=c++14

	local myconf=(
		# charls - not packaged in Gentoo ebuild repository
		# kakadu, mrsid jp2mrsid - another jpeg2k stuff, ignore
		# bsb - legal issues
		# ingres - same story as oracle oci
		# jasper - disabled because unmaintained and vulnerable; openjpeg will be used as JPEG-2000 provider instead
		# podofo - we use poppler instead they are exclusive for each other
		# tiff is a hard dep
		--includedir="${EPREFIX}"/usr/include/${PN}
		--disable-pdf-plugin
		--disable-static
		--enable-shared
		--with-expat
		--with-cryptopp=no
		--with-geotiff
		--with-grib
		--with-hide-internal-symbols
		--with-libjson-c="${EPREFIX}"/usr/
		--with-libtiff
		--with-libtool
		--with-libz="${EPREFIX}"/usr/
		--with-gnm
		--without-bsb
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
		--without-mrf
		--without-rasdaman
		--without-rasterlite2
		--without-pcraster
		--without-pdfium
		--without-podofo
		--without-qhull
		--without-sde
		--without-sfcgal
		--without-sosi
		--without-teigha
		--disable-lto
		$(use_enable debug)
		$(use_with armadillo)
		$(use_with aux-xml pam)
		$(use_with curl)
		$(use_with fits cfitsio)
		$(use_with geos)
		$(use_with gif)
		$(use_with gml xerces)
		$(use_with hdf5)
		$(use_with jpeg pcidsk) # pcidsk is internal, because there is no such library yreleased developer by gdal
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
		$(use_with perl)
		$(use_with png)
		$(use_with postgres pg)
		$(use_with python)
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
		tc-export PKG_CONFIG
		append-cflags $(${PKG_CONFIG} --cflags libtirpc)
		append-cxxflags $(${PKG_CONFIG} --cflags libtirpc)
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

	if use perl ; then
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
	if use perl ; then
		pushd "${S}"/swig/perl > /dev/null || die
		myinst=( DESTDIR="${D}" )
		perl-module_src_install
		popd > /dev/null || die
		sed -e 's:BINDINGS        =       \(.*\) perl:BINDINGS        =       \1:g' \
			-i GDALmake.opt || die
	fi

	use perl && perl_delete_localpod

	local DOCS=( Doxyfile HOWTO-RELEASE NEWS )
	use doc && HTML_DOCS=( html/. )

	default

	python_install() {
		distutils-r1_python_install
		python_doscript scripts/*.py
	}

	if use python; then
		# Don't clash with gdal's docs
		unset DOCS HTML_DOCS

		pushd "${S}"/swig/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die

		newdoc swig/python/README.txt README-python.txt

		insinto /usr/share/${PN}/samples
		doins -r swig/python/samples/
	fi

	doman "${S}"/man/man*/*
	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	elog "Check available image and data formats after building with"
	elog "gdalinfo and ogrinfo (using the --formats switch)."
}
