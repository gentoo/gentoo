# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WANT_AUTOCONF="2.5"

GENTOO_DEPEND_ON_PERL="no"
PYTHON_COMPAT=( python2_7 python3_{3,4} )
DISTUTILS_OPTIONAL=1

inherit autotools eutils libtool perl-module distutils-r1 python-r1 toolchain-funcs java-pkg-opt-2

DESCRIPTION="Translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="http://www.gdal.org/"
SRC_URI="http://download.osgeo.org/${PN}/${PV}/${P}.tar.gz"

SLOT="0/2"
LICENSE="BSD Info-ZIP MIT"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
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
	jpeg2k? ( media-libs/jasper )
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
MAKEOPTS+=" -j1"

REQUIRED_USE="
	spatialite? ( sqlite )
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

	# the second sed expression should fix bug 371075
	sed -i \
		-e "s:setup.py install:setup.py install --root=\$(DESTDIR):" \
		-e "s:--prefix=\$(DESTDIR):--prefix=:" \
		"${S}"/swig/python/GNUmakefile || die

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

	tc-export AR RANLIB

	eautoreconf

	prepare_python() {
		mkdir -p "${BUILD_DIR}" || die
		find "${S}" -type d -maxdepth 1 -exec ln -s {} "${BUILD_DIR}"/ \; ||die
		find "${S}" -type f -maxdepth 1 -exec cp --target="${BUILD_DIR}"/ {} + ||die
#		mkdir -p "${BUILD_DIR}"/swig/python || die
#		mkdir -p "${BUILD_DIR}"/apps || die
#		cp -dpR --target="${BUILD_DIR}"/swig/ \
#			"${S}"/swig/{python,SWIGmake.base,GNUmakefile} || die
#		ln -s "${S}"/swig/include "${BUILD_DIR}"/swig/ || die
#		ln -s "${S}"/apps/gdal-config "${BUILD_DIR}"/apps/ || die
#		ln -s "${S}"/port "${BUILD_DIR}"/ || die
	}
	if use python; then
		python_foreach_impl prepare_python
	fi
}

gdal_src_configure() {
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
		$(use_with python) \
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

	if [[ -n $use_python ]]; then
		# updated for newer swig (must specify the path to input files)
		sed -i \
			-e "s: gdal_array.i: ../include/gdal_array.i:" \
			-e "s:\$(DESTDIR)\$(prefix):\$(DESTDIR)\$(INST_PREFIX):g" \
			swig/python/GNUmakefile || die "sed python makefile failed"
		sed -i \
			-e "s:library_dirs = :library_dirs = /usr/$(get_libdir):g" \
			swig/python/setup.cfg || die "sed python setup.cfg failed"
#			-e "s:gdal_config=.*$:gdal_config=../../../apps/gdal-config:g" \
	fi
}

src_configure() {
	local use_python=""

	gdal_src_configure

	if use python; then
		use_python="yes"
		python_foreach_impl run_in_build_dir gdal_src_configure
	fi
}

src_compile() {
	if use perl; then
		rm "${S}"/swig/perl/*_wrap.cpp || die
		emake -C "${S}"/swig/perl generate
	fi

	default

	if use perl ; then
		pushd "${S}"/swig/perl > /dev/null
		perl-module_src_configure
		perl-module_src_compile
		popd > /dev/null
	fi

	use doc && emake docs

	compile_python() {
		rm -f swig/python/*_wrap.cpp || die
		emake -C swig/python generate
		emake -C swig/python build
	}
	if use python; then
		python_foreach_impl run_in_build_dir compile_python
	fi
}

src_install() {
	if use perl ; then
		pushd "${S}"/swig/perl > /dev/null
		perl-module_src_install
		popd > /dev/null
		sed -e 's:BINDINGS        =       \(.*\) perl:BINDINGS        =       \1:g' \
			-i GDALmake.opt || die
	fi

	default

	use perl && perl_delete_localpod

	dodoc Doxyfile HOWTO-RELEASE NEWS

	use doc && dohtml html/*

	install_python() {
		emake -C swig/python DESTDIR="${D}" install
	}
	if use python; then
		python_foreach_impl run_in_build_dir install_python
		newdoc swig/python/README.txt README-python.txt
		insinto /usr/share/${PN}/samples
		doins swig/python/samples/*
		python_replicate_script "${ED}"/usr/bin/*py
	fi

	pushd man/man1 > /dev/null
	for i in * ; do
		newman ${i} ${i}
	done
	popd > /dev/null
}

pkg_postinst() {
	elog "Check available image and data formats after building with"
	elog "gdalinfo and ogrinfo (using the --formats switch)."
}
