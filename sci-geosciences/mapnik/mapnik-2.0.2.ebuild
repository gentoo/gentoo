# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

PYTHON_DEPEND="python? 2"
MY_P="${PN}-v${PV}"

inherit eutils python scons-utils toolchain-funcs

DESCRIPTION="A Free Toolkit for developing mapping applications"
HOMEPAGE="http://www.mapnik.org/"
SRC_URI="http://github.com/downloads/${PN}/${PN}/${MY_P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="bidi cairo debug doc gdal geos postgres python sqlite"

RDEPEND="
	>=dev-libs/boost-1.48[python?]
	dev-libs/icu
	dev-libs/libxml2
	media-fonts/dejavu
	media-libs/freetype
	media-libs/libpng
	media-libs/tiff
	net-misc/curl
	sci-libs/proj
	sys-libs/zlib
	virtual/jpeg
	x11-libs/agg[truetype]
	bidi? ( dev-libs/fribidi )
	cairo? (
		x11-libs/cairo
		dev-cpp/cairomm
		python? ( dev-python/pycairo )
	)
	gdal? ( sci-libs/gdal )
	geos? ( sci-libs/geos )
	postgres? ( >=dev-db/postgresql-8.3 )
	sqlite? ( dev-db/sqlite:3 )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.0.1-scons.patch \
		"${FILESDIR}"/${PN}-2.0.1-configure-only-once.patch \
		"${FILESDIR}"/${PN}-2.0.1-destdir.patch \
		"${FILESDIR}"/${PN}-2.0.1-boost_build.patch

	# do not version epidoc data
	sed -i \
		-e 's:-`mapnik-config --version`::g' \
		utils/epydoc_config/build_epydoc.sh || die
}

src_configure() {
	local PLUGINS=shape,raster,osm
	use gdal && PLUGINS+=,gdal,ogr
	use geos && PLUGINS+=,geos
	use postgres && PLUGINS+=,postgis
	use sqlite && PLUGINS+=,sqlite

	myesconsargs=(
		"CC=$(tc-getCC)"
		"CXX=$(tc-getCXX)"
		"INPUT_PLUGINS=${PLUGINS}"
		"PREFIX=/usr"
		"XMLPARSER=libxml2"
		"LINKING=shared"
		"RUNTIME_LINK=shared"
		"PROJ_INCLUDES=/usr/include"
		"PROJ_LIBS=/usr/$(get_libdir)"
		"SYSTEM_FONTS=/usr/share/fonts"
		$(use_scons python BINDINGS all none)
		$(use_scons python BOOST_PYTHON_LIB boost_python-${PYTHON_ABI})
		$(use_scons bidi BIDI)
		$(use_scons cairo CAIRO)
		$(use_scons debug DEBUG)
		$(use_scons debug XML_DEBUG)
		$(use_scons doc DEMO)
		$(use_scons doc SAMPLE_INPUT_PLUGINS)
		"CUSTOM_LDFLAGS=${LDFLAGS}"
		"CUSTOM_LDFLAGS+=-L${ED}/usr/$(get_libdir)"
	)

	# force user flags, optimization level
	sed -i -e "s:\-O%s:${CXXFLAGS}:" \
		-i -e "s:env\['OPTIMIZATION'\]\,::" \
		SConstruct || die "sed 3 failed"
	escons configure
}

src_compile() {
	escons
}

src_install() {
	escons install

	# even with all the mess it still installs into $S
	mv "${S}/usr" "${ED}" || die

	if use python ; then
		fperms 0644 "$(python_get_sitedir)"/${PN}/paths.py
		dobin utils/stats/mapdef_stats.py
	fi

	dodoc AUTHORS.md README.md
}

pkg_postinst() {
	elog ""
	elog "See the home page or wiki (http://trac.mapnik.org/) for more info"
	elog "or the installed examples for the default mapnik ogcserver config."
	elog ""

	use python && python_mod_optimize ${PN}
}

pkg_postrm() {
	use python && python_mod_cleanup ${PN}
}
