# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/gdal/gdal-1.10.0-r1.ebuild,v 1.8 2015/02/28 15:52:54 jlec Exp $

EAPI=5

WANT_AUTOCONF="2.5"

PYTHON_DEPEND="python? *"

inherit autotools eutils libtool perl-module python toolchain-funcs java-pkg-opt-2

DESCRIPTION="Translator library for raster geospatial data formats (includes OGR support)"
HOMEPAGE="http://www.gdal.org/"
SRC_URI="http://download.osgeo.org/${PN}/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="armadillo +aux_xml curl debug doc fits geos gif gml hdf5 java jpeg jpeg2k mdb mysql netcdf odbc opencl pdf perl png postgres python ruby spatialite sqlite threads xls"

RDEPEND="
	dev-libs/expat
	media-libs/tiff:0=
	sci-libs/libgeotiff
	|| ( <sys-libs/zlib-1.2.5.1-r1 >=sys-libs/zlib-1.2.5.1-r2[minizip] )
	armadillo? ( sci-libs/armadillo[lapack] )
	curl? ( net-misc/curl )
	fits? ( sci-libs/cfitsio )
	geos?   ( >=sci-libs/geos-2.2.1 )
	gif? ( media-libs/giflib )
	gml? ( >=dev-libs/xerces-c-3 )
	hdf5? ( >=sci-libs/hdf5-1.6.4[szip] )
	java? ( >=virtual/jre-1.6:* )
	jpeg? ( virtual/jpeg:0= )
	jpeg2k? ( media-libs/jasper )
	mysql? ( virtual/mysql )
	netcdf? ( sci-libs/netcdf )
	odbc?   ( dev-db/unixODBC )
	opencl? ( virtual/opencl )
	pdf? ( app-text/poppler )
	perl? ( dev-lang/perl )
	png? ( media-libs/libpng:0= )
	postgres? ( >=dev-db/postgresql-8.4:= )
	python? ( dev-python/numpy )
	ruby? ( dev-lang/ruby:1.9 )
	sqlite? ( dev-db/sqlite:3 )
	spatialite? ( dev-db/spatialite )
	xls? ( dev-libs/freexl )
"

SWIG_DEP=">=dev-lang/swig-2.0.2"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.6 )
	perl? ( ${SWIG_DEP} )
	python? ( ${SWIG_DEP} )
	ruby? ( ${SWIG_DEP} )"

AT_M4DIR="${S}/m4"
MAKEOPTS+=" -j1"

REQUIRED_USE="
	spatialite? ( sqlite )
	mdb? ( java )
"

pkg_setup() {
	use python && python_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with the src path
	default
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

	epatch "${FILESDIR}"/${PN}-1.9.1-ruby-makefile.patch

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
}

src_configure() {
	local myopts=""

	if use ruby; then
		RUBY_MOD_DIR="$(ruby19 -r rbconfig -e 'print RbConfig::CONFIG["sitearchdir"]')"
		echo "Ruby module dir is: $RUBY_MOD_DIR"
	fi

	if use python; then
		myopts+="
			--with-pymoddir="${EPREFIX}"/$(python_get_sitedir)
		"
	fi

	if use java; then
		myopts+="
			--with-java=$(java-config --jdk-home 2>/dev/null)
			$(use_with mdb)"
	else
		myopts+=" --without-java --without-mdb"
		use mdb && ewarn "mdb requires java use enabled. disabling"
	fi

	# pcidsk is internal, because there is no such library yet released
	#     also that thing is developed by the gdal people
	# kakadu, mrsid jp2mrsid - another jpeg2k stuff, ignore
	# bsb - legal issues
	# oracle - disabled, i dont have and can't test
	# ingres - same story as oracle oci
	# podofo - we use poppler instead they are exclusive for each other
	# tiff is a hard dep
	econf \
		--enable-shared \
		--disable-static \
		--with-expat \
		--without-grass \
		--without-hdf4 \
		--without-fme \
		--without-pcraster \
		--without-kakadu \
		--without-mrsid \
		--without-jp2mrsid \
		--without-msg \
		--without-bsb \
		--without-dods-root \
		--without-oci \
		--without-ingres \
		--without-dwgdirect \
		--without-epsilon \
		--without-idb \
		--without-podofo \
		--without-sde \
		--without-libtool \
		--with-libz="${EPREFIX}/usr/" \
		--with-ogr \
		--with-grib \
		--with-libtiff \
		--with-geotiff \
		$(use_enable debug) \
		$(use_with armadillo) \
		$(use_with postgres pg) \
		$(use_with fits cfitsio) \
		$(use_with netcdf) \
		$(use_with png) \
		$(use_with jpeg) \
		$(use_with jpeg pcidsk) \
		$(use_with gif) \
		$(use_with hdf5) \
		$(use_with jpeg2k jasper) \
		--without-ecw \
		$(use_with gml xerces) \
		$(use_with odbc) \
		$(use_with opencl) \
		$(use_with curl) \
		$(use_with sqlite sqlite3 "${EPREFIX}"/usr) \
		$(use_with spatialite) \
		$(use_with mysql mysql "${EPREFIX}"/usr/bin/mysql_config) \
		$(use_with geos) \
		$(use_with aux_xml pam) \
		$(use_with pdf poppler) \
		$(use_with perl) \
		$(use_with ruby) \
		$(use_with python) \
		$(use_with threads) \
		$(use_with xls freexl) \
		${myopts}

	# mysql-config puts this in (and boy is it a PITA to get it out)
	if use mysql; then
		sed -i \
			-e "s: -rdynamic : :" \
			GDALmake.opt || die "sed LIBS failed"
	fi

	# updated for newer swig (must specify the path to input files)
	if use python; then
		sed -i \
			-e "s: gdal_array.i: ../include/gdal_array.i:" \
			-e "s:\$(DESTDIR)\$(prefix):\$(DESTDIR)\$(INST_PREFIX):g" \
			swig/python/GNUmakefile || die "sed python makefile failed"
		sed -i \
			-e "s:library_dirs = :library_dirs = /usr/$(get_libdir):g" \
			swig/python/setup.cfg || die "sed python setup.cfg failed"
	fi
}

src_compile() {
	local i
	for i in perl ruby python; do
		if use $i; then
			rm "${S}"/swig/$i/*_wrap.cpp
			emake -C "${S}"/swig/$i generate
		fi
	done

	default

	if use perl ; then
		pushd "${S}"/swig/perl > /dev/null
		perl-module_src_configure
		perl-module_src_compile
		popd > /dev/null
	fi

	use doc && emake docs
}

src_install() {
	if use perl ; then
		pushd "${S}"/swig/perl > /dev/null
		perl-module_src_install
		popd > /dev/null
		sed -i \
			-e "s:BINDINGS        =       python ruby perl:BINDINGS        =       python ruby:g" \
			GDALmake.opt || die
	fi

	default

	if use ruby ; then
		# weird reinstall collision; needs manual intervention...
		pushd "${S}"/swig/ruby > /dev/null
		rm -rf "${D}"${RUBY_MOD_DIR}/gdal
		exeinto ${RUBY_MOD_DIR}/gdal
		doexe *.so || die "doins ruby modules failed"
		popd > /dev/null
	fi

	use perl && perl_delete_localpod

	dodoc Doxyfile HOWTO-RELEASE NEWS

	if use doc ; then
		dohtml html/*
		docinto ogr
		dohtml ogr/html/*
	fi

	if use python; then
		newdoc swig/python/README.txt README-python.txt
		insinto /usr/share/${PN}/samples
		doins swig/python/samples/*
	fi

	pushd man/man1 > /dev/null
	for i in * ; do
		newman ${i} ${i}
	done
	popd > /dev/null
}

pkg_postinst() {
	if use python; then
		python_need_rebuild
		python_mod_optimize osgeo
	fi
	echo
	elog "Check available image and data formats after building with"
	elog "gdalinfo and ogrinfo (using the --formats switch)."
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup osgeo
	fi
}
