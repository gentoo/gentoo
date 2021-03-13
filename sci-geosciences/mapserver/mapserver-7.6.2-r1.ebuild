# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Variables for the miscellaneous bindings we provide
PHP_EXT_OPTIONAL_USE="php"
PHP_EXT_NAME="php_mapscriptng"
PHP_EXT_SKIP_PHPIZE="yes"

USE_PHP="php7-3 php7-4"
PYTHON_COMPAT=( python3_{7,8,9} )

WEBAPP_MANUAL_SLOT=yes
WEBAPP_OPTIONAL=yes

inherit cmake depend.apache perl-functions php-ext-source-r3 python-r1 webapp

DESCRIPTION="Development environment for building spatially enabled webapps"
HOMEPAGE="https://mapserver.org/"
SRC_URI="https://download.osgeo.org/mapserver/${P}.tar.gz"

LICENSE="Boost-1.0 BSD BSD-2 ISC MIT tcltk"
KEYWORDS="~amd64 ~x86"
SLOT="0"

# NOTE: opengl removed for now as no support for it in upstream CMake
IUSE="apache bidi cairo geos mysql oracle perl php postgis python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Tests:
# Included tests (tests/*) are seriously outdated
# Upstream's main test suite (msautotest/*) is not in the release tarball,
# and upstream sets 'export-ignore' for that directory.
#
# The eclasses used normally try to run test suites themselves,
# or skip if nothing was found.
# However, because of the php-ext-* eclass usage, this fails and would
# cause errors running non-existent tests, so we have to restrict here.
RESTRICT="test"

RDEPEND="
	>=dev-libs/expat-2.2.8
	dev-libs/libxml2:2=
	dev-libs/libxslt[crypt]
	>=dev-libs/protobuf-c-1.3.2:=
	>=media-libs/freetype-2.9.1-r3
	>=media-libs/gd-2.0.12:=[truetype,jpeg,png,zlib]
	>=media-libs/giflib-5.2.1:=
	>=media-libs/libpng-1.6.37:=
	>=net-misc/curl-7.69.1
	>=sci-libs/gdal-3.0.4:=[oracle?]
	>=sci-libs/proj-6.2.1:=
	virtual/jpeg
	virtual/libiconv
	>=x11-libs/agg-2.5-r3
	apache? (
		app-admin/webapp-config
		dev-libs/fcgi
	)
	bidi? (
		dev-libs/fribidi
		media-libs/harfbuzz:=
	)
	cairo? ( x11-libs/cairo )
	geos? ( sci-libs/geos )
	mysql? ( dev-db/mysql-connector-c:= )
	oracle? ( dev-db/oracle-instantclient:=	)
	perl? ( dev-lang/perl:= )
	postgis? (
		dev-db/postgis
		dev-db/postgresql:=
	)
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	perl? ( >=dev-lang/swig-4.0 )
	php? ( >=dev-lang/swig-4.0 )
	python? (
		>=dev-lang/swig-4.0
		>=dev-python/setuptools-44.1.0
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-proj8.patch
)

want_apache2 apache

pkg_setup() {
	use apache && webapp_pkg_setup
	use perl && perl_set_version
}

src_prepare() {
	cmake_src_prepare

	use php && php-ext-source-r3_src_prepare
	use python && python_copy_sources
}

_generate_cmake_args() {
	# Provides a simple, bare config for bindings to build upon
	# Need WITH_WMS=ON or build fails
	local args=(
		"-DCMAKE_SKIP_RPATH=ON"
		"-DINSTALL_LIB_DIR=/usr/$(get_libdir)"
		"-DWITH_CAIRO=OFF"
		"-DWITH_FCGI=OFF"
		"-DWITH_FRIBIDI=OFF"
		"-DWITH_GEOS=OFF"
		"-DWITH_GIF=OFF"
		"-DWITH_HARFBUZZ=OFF"
		"-DWITH_ICONV=OFF"
		"-DWITH_PROTOBUFC=OFF"
		"-DWITH_POSTGIS=OFF"
		"-DWITH_WMS=ON"
		"-DWITH_WCS=OFF"
		"-DWITH_WFS=OFF"
	)

	echo "${args[@]}"
}

src_configure() {
	# NOTE: We could make this based on _generate_cmake_args, but
	# then we wouldn't be as-explicit about what is enabled/not,
	# and reliant on defaults not changing.
	# Readability and maintainability is better this way.
	local mycmakeargs=(
		"-DCMAKE_SKIP_RPATH=ON"
		"-DINSTALL_LIB_DIR=/usr/$(get_libdir)"
		"-DWITH_CLIENT_WMS=ON"
		"-DWITH_CLIENT_WFS=ON"
		"-DWITH_CURL=ON"
		"-DWITH_GIF=ON"
		"-DWITH_ICONV=ON"
		"-DWITH_KML=ON"
		"-DWITH_LIBXML2=ON"
		"-DWITH_PHPNG=OFF"
		"-DWITH_PROTOBUFC=ON"
		"-DWITH_SOS=ON"
		"-DWITH_WMS=ON"
		"-DWITH_WFS=ON"
		"-DWITH_WCS=ON"
		"-DWITH_XMLMAPFILE=ON"
		"-DWITH_APACHE_MODULE=$(usex apache ON OFF)"
		"-DWITH_CAIRO=$(usex cairo ON OFF)"
		"-DWITH_FCGI=$(usex apache ON OFF)"
		"-DWITH_GEOS=$(usex geos ON OFF)"
		"-DWITH_ORACLESPATIAL=$(usex oracle ON OFF)"
		"-DWITH_MYSQL=$(usex mysql ON OFF)"
		"-DWITH_FRIBIDI=$(usex bidi ON OFF)"
		"-DWITH_HARFBUZZ=$(usex bidi ON OFF)"
		"-DWITH_POSTGIS=$(usex postgis ON OFF)"
		"-DWITH_PERL=$(usex perl ON OFF)"
	)

	use perl && mycmakeargs+=( "-DCUSTOM_PERL_SITE_ARCH_DIR=$(perl_get_raw_vendorlib)" )

	# Configure the standard build first
	cmake_src_configure

	# Minimal build for bindings
	# Note that we use _generate_cmake_args to get a clean config each time, then add
	# in options as appropriate. Otherwise we'd get contamination between bindings.
	if use python ; then
		mycmakeargs=(
			$(_generate_cmake_args)
			"-DWITH_PYTHON=ON"
		)

		python_foreach_impl cmake_src_configure
		python_foreach_impl python_optimize
	fi

	if use php ; then
		local slot=
		for slot in $(php_get_slots) ; do
			# Switch to the slot's build dir
			php_init_slot_env "${slot}"

			# Take a blank config each time
			# Add in only *this* slot's PHP includes dir, etc
			mycmakeargs=(
				$(_generate_cmake_args)
				"-DWITH_PHPNG=ON"
				"-DPHP_CONFIG_EXECUTABLE=${PHPCONFIG}"
				"-DPHP_INCLUDES=${PHPPREFIX}"
			)

			BUILD_DIR="${S}/php${slot}" cmake_src_configure

			# Return to where we left off, in case we add more
			# to this phase.
			cd "${S}" || die
		done
	fi
}

src_compile() {
	cmake_src_compile

	if use python ; then
		python_foreach_impl cmake_src_compile
	fi

	if use php ; then
		local slot=
		for slot in $(php_get_slots) ; do
			# Switch to the slot's build dir
			php_init_slot_env "${slot}"

			# Force cmake to build in it
			BUILD_DIR="${S}/php${slot}" cmake_src_compile

			# Return to where we left off, in case we add more
			# to this phase.
			cd "${S}" || die
		done
	fi
}

src_install() {
	# Needs to be first
	use apache && webapp_src_preinst

	if use python ; then
		python_foreach_impl cmake_src_install
		python_foreach_impl python_optimize
	fi

	if use php ; then
		php-ext-source-r3_createinifiles

		local slot=
		for slot in $(php_get_slots) ; do
			php_init_slot_env "${slot}"

			BUILD_DIR="${S}/php${slot}" cmake_src_install

			cd "${S}" || die
		done
	fi

	# Install this last because this build is the most "fully-featured"
	cmake_src_install

	if use apache ; then
		# We need a mapserver symlink available in cgi-bin
		dosym ../../../../../../../usr/bin/mapserv /usr/share/webapps/${PN}/${PV}/hostroot/cgi-bin/mapserv
		webapp_src_install
	fi
}

pkg_preinst() {
	# We need to cache the value here of HAD_PHP because we want the
	# original package version, not the result of us installing a new one
	HAD_PHP=
	has_version 'sci-geosciences/mapserver[php]' && HAD_PHP=1
}

pkg_postinst() {
	use apache && webapp_pkg_postinst

	# Let upgrading (from a pre-rewrite version) users know that the PHP module changed
	local replacing_version=
	for replacing_version in ${REPLACING_VERSIONS} ; do
		if ver_test "7.6.0" -gt "${replacing_version}" ; then
			if use php && [[ ${HAD_PHP} -eq 1 ]] ; then
				elog "Note that MapServer has deprecated the old PHP extension"
				elog "You can read more at: "
				elog "URL: https://mapserver.org/MIGRATION_GUIDE.html#mapserver-7-2-to-7-4-migration"
				elog "This may involve porting some of your PHP scripts to use the new module."
			fi

			# Only show the message once
			break
		fi
	done
}

pkg_prerm() {
	use apache && webapp_pkg_prerm
}
