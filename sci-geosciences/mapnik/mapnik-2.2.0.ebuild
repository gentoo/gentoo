# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )
MY_P="${PN}-v${PV}"

inherit eutils python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="A Free Toolkit for developing mapping applications"
HOMEPAGE="http://www.mapnik.org/"
SRC_URI="http://mapnik.s3.amazonaws.com/dist/v${PV}/${MY_P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="cairo debug doc gdal postgres python sqlite"

RDEPEND="
	>=dev-libs/boost-1.48[threads,python?]
	dev-libs/icu:=
	sys-libs/zlib
	media-libs/freetype
	dev-libs/libxml2
	media-libs/libpng
	media-libs/tiff
	virtual/jpeg
	media-libs/libwebp
	sci-libs/proj
	media-fonts/dejavu
	x11-libs/agg[truetype]
	net-misc/curl
	cairo? (
		x11-libs/cairo
		dev-cpp/cairomm
		python? ( dev-python/pycairo[${PYTHON_USEDEP}] )
	)
	postgres? ( >=dev-db/postgresql-8.3 )
	gdal? ( sci-libs/gdal )
	sqlite? ( dev-db/sqlite:3 )
	python_single_target_python3_3? ( >=dev-libs/boost-1.53[${PYTHON_USEDEP}] )
"

DEPEND="${RDEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-configure-only-once.patch \
		"${FILESDIR}"/${P}-dont-run-ldconfig.patch \
		"${FILESDIR}"/${P}-scons.patch \
		"${FILESDIR}"/${P}-python3.patch

	# do not version epidoc data
	sed -i \
		-e 's:-`mapnik-config --version`::g' \
		utils/epydoc_config/build_epydoc.sh || die

	# force user flags, optimization level
	sed -i -e "s:\-O%s:%s:" \
		-i -e "s:env\['OPTIMIZATION'\]:'${CXXFLAGS}':" \
		SConstruct || die

	epatch_user
}

src_configure() {
	local PLUGINS=shape,csv,raster,geojson,osm
	use gdal && PLUGINS+=,gdal,ogr
	use postgres && PLUGINS+=,postgis
	use sqlite && PLUGINS+=,sqlite
	use python && PLUGINS+=,python

	myesconsargs=(
		"CC=$(tc-getCC)"
		"CXX=$(tc-getCXX)"
		"INPUT_PLUGINS=${PLUGINS}"
		"PREFIX=/usr"
		"DESTDIR=${D}"
		"XMLPARSER=libxml2"
		"LINKING=shared"
		"RUNTIME_LINK=shared"
		"PROJ_INCLUDES=/usr/include"
		"PROJ_LIBS=/usr/$(get_libdir)"
		"SYSTEM_FONTS=/usr/share/fonts"
		$(use_scons python BINDINGS all none)
		$(use python && use_scons python PYTHON $PYTHON)
		$(use_scons python BOOST_PYTHON_LIB boost_python-$(echo $EPYTHON | sed 's/python//'))
		$(use_scons cairo CAIRO)
		$(use_scons debug DEBUG)
		$(use_scons debug XML_DEBUG)
		$(use_scons doc DEMO)
		$(use_scons doc SAMPLE_INPUT_PLUGINS)
		"CUSTOM_LDFLAGS=${LDFLAGS}"
		"CUSTOM_LDFLAGS+=-L${ED}/usr/$(get_libdir)"
	)

	escons configure
}

src_compile() {
	escons
}

src_install() {
	escons install

	if use python ; then
		python_optimize
		fperms 0644 "$(python_get_sitedir)"/${PN}/paths.py
		dobin utils/stats/mapdef_stats.py
	fi

	dodoc AUTHORS.md README.md CHANGELOG.md
}

pkg_postinst() {
	elog ""
	elog "See the home page or wiki (http://trac.mapnik.org/) for more info"
	elog "or the installed examples for the default mapnik ogcserver config."
	elog ""
}
