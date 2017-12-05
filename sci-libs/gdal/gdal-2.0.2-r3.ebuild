# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WANT_AUTOCONF="2.5"

GENTOO_DEPEND_ON_PERL="no"
PYTHON_COMPAT=( python2_7 python3_4 )
DISTUTILS_OPTIONAL=1

inherit autotools eutils libtool perl-module distutils-r1 flag-o-matic toolchain-funcs java-pkg-opt-2

DESCRIPTION="Translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="http://www.gdal.org/"
SRC_URI="http://download.osgeo.org/${PN}/${PV}/${P}.tar.gz"

SLOT="0/2"
LICENSE="BSD Info-ZIP MIT"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="armadillo +aux_xml curl debug doc fits geos gif gml hdf5 java jpeg jpeg2k mdb mysql netcdf odbc ogdi opencl pdf perl png postgres python spatialite sqlite threads xls"

RDEPEND="
	dev-libs/expat
	dev-libs/json-c
	dev-libs/libpcre
	dev-libs/libxml2
	media-libs/tiff:0=
	sci-libs/libgeotiff
	sys-libs/zlib[minizip(+)]
	armadillo? ( sci-libs/armadillo[lapack] )
	curl? ( net-misc/curl )
	fits? ( sci-libs/cfitsio )
	geos?   ( >=sci-libs/geos-2.2.1 )
	gif? ( media-libs/giflib:= )
	gml? ( >=dev-libs/xerces-c-3 )
	hdf5? ( >=sci-libs/hdf5-1.6.4[szip] )
	java? ( >=virtual/jre-1.6:* )
	jpeg? ( virtual/jpeg:0= )
	jpeg2k? ( media-libs/jasper:= )
	mysql? ( virtual/mysql )
	netcdf? ( sci-libs/netcdf )
	odbc?   ( dev-db/unixODBC )
	ogdi? ( sci-libs/ogdi )
	opencl? ( virtual/opencl )
	pdf? ( >=app-text/poppler-0.24.3:= )
	perl? ( dev-lang/perl:= )
	png? ( media-libs/libpng:0= )
	postgres? ( >=dev-db/postgresql-8.4:= )
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	sqlite? ( dev-db/sqlite:3 )
	spatialite? ( dev-db/spatialite )
	xls? ( dev-libs/freexl )
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.6 )
	perl? ( dev-lang/swig:0 )
	python? ( dev-lang/swig:0 )"

AT_M4DIR="${S}/m4"

REQUIRED_USE="
	spatialite? ( sqlite )
	python? ( ${PYTHON_REQUIRED_USE} )
	mdb? ( java )
"

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	java-pkg-opt-2_src_prepare

	# fix datadir and docdir placement
	sed -i \
		-e "s:@datadir@:@datadir@/gdal:" \
		-e "s:@exec_prefix@/doc:@exec_prefix@/share/doc/${PF}/html:g" \
		"${S}"/GDALmake.opt.in || die

	if use jpeg2k; then
		epatch "${FILESDIR}"/${P}-jasper.patch
		epatch "${FILESDIR}"/${P}-jasper2.patch #bug 599626
	fi

	# -soname is only accepted by GNU ld/ELF
	[[ ${CHOST} == *-darwin* ]] \
		&& epatch "${FILESDIR}"/${PN}-1.5.0-install_name.patch \
		|| epatch "${FILESDIR}"/${PN}-1.5.0-soname.patch

	# Fix spatialite/sqlite include issue
	sed -i \
		-e 's:spatialite/sqlite3.h:sqlite3.h:g' \
		ogr/ogrsf_frmts/sqlite/ogr_sqlite.h || die

	# Fix freexl configure check
	sed -i \
		-e 's:FREEXL_LIBS=missing):FREEXL_LIBS=missing,-lm):g' \
		configure.in || die

	sed \
		-e "s: /usr/: \"${EPREFIX}\"/usr/:g" \
		-i configure.in || die

	sed \
		-e 's:^ar:$(AR):g' \
		-i ogr/ogrsf_frmts/sdts/install-libs.sh || die

	# updated for newer swig (must specify the path to input files)
	sed -i \
		-e "s: gdal_array.i: ../include/gdal_array.i:" \
		-e "s:\$(DESTDIR)\$(prefix):\$(DESTDIR)\$(INST_PREFIX):g" \
		swig/python/GNUmakefile || die "sed python makefile failed"
	sed -i \
		-e "s:library_dirs = :library_dirs = /usr/$(get_libdir):g" \
		swig/python/setup.cfg || die "sed python setup.cfg failed"

	# bug 626844, poppler headers require C++11
	use pdf && append-cxxflags -std=c++11

	tc-export AR RANLIB

	eautoreconf
}

src_configure() {
	local myopts=""

	if use java; then
		myopts+="
			--with-java=$(java-config --jdk-home 2>/dev/null)
			$(use_with mdb)"
	else
		myopts+=" --without-java --without-mdb"
		use mdb && ewarn "mdb requires java use enabled. disabling"
	fi

	if use sqlite; then
		myopts+=" LIBS=-lsqlite3"
	fi

	# pcidsk is internal, because there is no such library yet released
	#     also that thing is developed by the gdal people
	# kakadu, mrsid jp2mrsid - another jpeg2k stuff, ignore
	# bsb - legal issues
	# oracle - disabled, i dont have and can't test
	# ingres - same story as oracle oci
	# podofo - we use poppler instead they are exclusive for each other
	# tiff is a hard dep
	ECONF_SOURCE="${S}" econf \
		--includedir="${EPREFIX}/usr/include/${PN}" \
		--disable-static \
		--enable-shared \
		--with-expat \
		--with-geotiff \
		--with-grib \
		--with-libtiff \
		--with-libz="${EPREFIX}/usr/" \
		--with-ogr \
		--without-bsb \
		--without-dods-root \
		--without-dwgdirect \
		--without-epsilon \
		--without-fme \
		--without-grass \
		--without-hdf4 \
		--without-idb \
		--without-ingres \
		--without-jp2mrsid \
		--without-kakadu \
		--without-libtool \
		--without-mrsid \
		--without-msg \
		--without-oci \
		--without-pcraster \
		--without-podofo \
		--without-python \
		--without-sde \
		$(use_enable debug) \
		$(use_with armadillo) \
		$(use_with aux_xml pam) \
		$(use_with curl) \
		--without-ecw \
		$(use_with fits cfitsio) \
		$(use_with geos) \
		$(use_with gif) \
		$(use_with gml xerces) \
		$(use_with hdf5) \
		$(use_with jpeg pcidsk) \
		$(use_with jpeg) \
		$(use_with jpeg2k jasper) \
		$(use_with mysql mysql "${EPREFIX}"/usr/bin/mysql_config) \
		$(use_with netcdf) \
		$(use_with odbc) \
		$(use_with ogdi ogdi "${EPREFIX}"/usr) \
		$(use_with opencl) \
		$(use_with pdf poppler) \
		$(use_with perl) \
		$(use_with png) \
		$(use_with postgres pg) \
		$(use_with spatialite) \
		$(use_with sqlite sqlite3 "${EPREFIX}"/usr) \
		$(use_with threads) \
		$(use_with xls freexl) \
		${myopts}

	# mysql-config puts this in (and boy is it a PITA to get it out)
	if use mysql; then
		sed -i \
			-e "s: -rdynamic : :" \
			GDALmake.opt || die "sed LIBS failed"
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
		rm -f "${S}"swig/python/*_wrap.cpp || die
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
		perl-module_src_install
		popd > /dev/null || die
		sed -e 's:BINDINGS        =       \(.*\) perl:BINDINGS        =       \1:g' \
			-i GDALmake.opt || die
	fi

	default

	use perl && perl_delete_localpod

	dodoc Doxyfile HOWTO-RELEASE NEWS

	use doc && dohtml html/*

	python_install() {
		distutils-r1_python_install
		python_doscript scripts/*.py
	}
	if use python; then
		pushd "${S}"/swig/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
		newdoc swig/python/README.txt README-python.txt
		insinto /usr/share/${PN}/samples
		doins swig/python/samples/*
	fi

	pushd man/man1 > /dev/null || die
	for i in * ; do
		newman ${i} ${i}
	done
	popd > /dev/null || die
}

pkg_postinst() {
	elog "Check available image and data formats after building with"
	elog "gdalinfo and ogrinfo (using the --formats switch)."
}
