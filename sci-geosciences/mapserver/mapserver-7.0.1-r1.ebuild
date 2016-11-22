# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="${PN}-${PV/_/-}"

PHP_EXT_OPTIONAL_USE="php"
PHP_EXT_NAME="php_mapscript"
PHP_EXT_S="${WORKDIR}/${MY_P}/mapscript/php/"
PHP_EXT_SKIP_PHPIZE="no"
USE_PHP="php5-6 php5-5"

PYTHON_COMPAT=( python2_7 )

#USE_RUBY="ruby18 ruby19"
#RUBY_OPTIONAL="yes"

WEBAPP_MANUAL_SLOT=yes

inherit eutils depend.apache webapp distutils-r1 flag-o-matic perl-module php-ext-source-r2 multilib cmake-utils # ruby-ng

DESCRIPTION="Development environment for building spatially enabled webapps"
HOMEPAGE="http://mapserver.org/"
SRC_URI="http://download.osgeo.org/mapserver/${MY_P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="bidi cairo gdal geos mysql opengl perl php postgis proj python threads tiff xml xslt" # ruby php tcl

REQUIRED_USE="php? ( ^^ ( php_targets_php5-6 php_targets_php5-5 ) )
			xslt? ( xml )"

RDEPEND="
	dev-libs/expat
	dev-libs/fcgi
	>=media-libs/gd-2.0.12[truetype,jpeg,png,zlib]
	media-libs/giflib
	net-misc/curl
	virtual/jpeg:=
	virtual/libiconv
	x11-libs/agg
	bidi? ( dev-libs/fribidi
			media-libs/harfbuzz )
	cairo? ( x11-libs/cairo )
	gdal? ( >=sci-libs/gdal-1.8.0 )
	geos? ( sci-libs/geos )
	mysql? ( virtual/mysql )
	opengl? (
		media-libs/ftgl
		media-libs/mesa
	)
	perl? ( dev-lang/perl:= )
	postgis? ( dev-db/postgis )
	proj? ( sci-libs/proj net-misc/curl )
	tiff? (
		media-libs/tiff:=
		sci-libs/libgeotiff
	)
	xml? ( dev-libs/libxml2:2 )
	xslt? ( dev-libs/libxslt[crypt] )
"
DEPEND="${RDEPEND}
	perl? ( >=dev-lang/swig-2.0 )
	python? ( >=dev-lang/swig-2.0 )"

need_apache2

PATCHES=(
	"${FILESDIR}/${PN}-7.0.0-sec-format.patch"  # see https://github.com/mapserver/mapserver/pull/5248
	"${FILESDIR}/${PN}-7.0.0-no-applicable-code.patch"
)

S=${WORKDIR}/${MY_P}

pkg_setup() {
	webapp_pkg_setup
	use perl && perl_set_version
	#use ruby && ruby-ng_pkg_setup
}

src_unpack() {
	# unpack A and then copy the php thingies into workdir/php-slot
	php-ext-source-r2_src_unpack
	# HACK: and then remove it and replace by symlink
	local slot
	for slot in $(php_get_slots); do
		rm -rf "${WORKDIR}/${slot}" || die
		ln -s "${PHP_EXT_S}" "${WORKDIR}/${slot}" || die
	done
}

src_prepare() {
	local glibdir="${EPREFIX}/usr/include/glib-2.0"
	local usrglibdir="${EPREFIX}/usr/$(get_libdir)/glib-2.0/include"

	sed -e "s:^include_directories(:&${glibdir})\ninclude_directories(:" \
		-i "${S}/CMakeLists.txt" || die
	sed -e "s:include_directories(:&${usrglibdir})\ninclude_directories(:" \
		-i "${S}/CMakeLists.txt" || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_SKIP_RPATH=ON"
		"-DWITH_ORACLESPATIAL=OFF"
		"-DWITH_SDE=OFF"
		"-DWITH_APACHE_MODULE=ON"
		"-DWITH_ICONV=ON"
		"-DWITH_GD=ON"
		"-DWITH_GIF=ON"
		"-DWITH_CURL=ON"
		"-DWITH_FCGI=ON"
		"-DINSTALL_LIB_DIR=${ROOT}usr/$(get_libdir)"
		"-DWITH_PROJ=$(usex proj ON OFF)"
		"-DWITH_WMS=$(usex proj ON OFF)"
		"-DWITH_KML=$(usex xml ON OFF)"
		"-DWITH_GEOS=$(usex geos ON OFF)"
		"-DWITH_GDAL=$(usex gdal ON OFF)"
		"-DWITH_OGR=$(usex gdal ON OFF)"
		"-DWITH_POSTGIS=$(usex postgis ON OFF)"
		"-DWITH_MYSQL=$(usex mysql ON OFF)"
		"-DWITH_LIBXML2=$(usex xml ON OFF)"
		"-DWITH_XMLMAPFILE=$(usex xslt ON OFF)"
		"-DWITH_FRIBIDI=$(usex bidi ON OFF)"
		"-DWITH_HARFBUZZ=$(usex bidi ON OFF)"
		"-DWITH_CAIRO=$(usex cairo ON OFF)"
		"-DWITH_PHP=$(usex php ON OFF)"
		"-DWITH_PYTHON=$(usex python ON OFF)"
		"-DWITH_PERL=$(usex perl ON OFF)"
	)

	if use gdal && use proj ; then
		mycmakeargs+=( "-DWITH_WFS=ON"
				"-DWITH_WCS=ON"
				"-DWITH_CLIENT_WMS=ON"
				"-DWITH_CLIENT_WFS=ON"
				"-DWITH_SOS=$(usex xml ON OFF)"
			)
	else
		mycmakeargs+=( "-DWITH_WFS=OFF"
			"-DWITH_WCS=OFF"
			"-DWITH_CLIENT_WMS=OFF"
			"-DWITH_CLIENT_WFS=OFF"
			"-DWITH_SOS=OFF"
		)
	fi

	if use php ; then
		local slot
		for slot in $(php_get_slots); do
			mycmakeargs+=( -DPHP5_CONFIG_EXECUTABLE="${EPREFIX}/usr/$(get_libdir)/${slot}/bin/php-config" )
		done
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	if use php ; then
		php-ext-source-r2_createinifiles
	fi
	webapp_src_preinst
	exeinto "${MY_CGIBINDIR}"
	doexe "${S}_build/mapserv"
	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
}

pkg_prerm() {
	webapp_pkg_prerm
}
