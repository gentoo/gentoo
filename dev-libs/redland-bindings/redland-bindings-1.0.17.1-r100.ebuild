# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )
PYTHON_COMPAT=( python3_{7..9} )

USE_PHP="php7-2 php7-3 php7-4"
PHP_EXT_ECONF_ARGS="--with-php=yes --without-lua --without-perl --without-python --without-ruby"
PHP_EXT_NAME="redland"
PHP_EXT_OPTIONAL_USE="php"
PHP_EXT_SKIP_PATCHES="yes"
PHP_EXT_SKIP_PHPIZE="yes"

inherit lua php-ext-source-r3 python-single-r1 autotools

DESCRIPTION="Language bindings for Redland"
HOMEPAGE="http://librdf.org/bindings/"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="lua perl python php ruby test"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

BDEPEND="sys-apps/sed
	virtual/pkgconfig"

RDEPEND=">=dev-libs/redland-1.0.14
	lua? ( ${LUA_DEPS} )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:* dev-ruby/log4r )
	php? (
		php_targets_php7-2? ( dev-lang/php:7.2[-threads] )
		php_targets_php7-3? ( dev-lang/php:7.3[-threads] )
		php_targets_php7-4? ( dev-lang/php:7.4[-threads] )
	)"

DEPEND="${RDEPEND}
	>=dev-lang/swig-2
	test? (
		>=dev-libs/redland-1.0.14[berkdb]
	)"

PATCHES=(
	"${FILESDIR}"/${P}-bool.patch
	"${FILESDIR}"/${PN}-1.0.17.1-php-config-r1.patch
	"${FILESDIR}"/${PN}-1.0.17.1-add-PHP7-support.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	eautoreconf

	# As of version 1.0.17.1, out-of-tree builds fail with:
	# "error: redland_wrap.c: No such file or directory",
	# have to copy the sources.
	use lua && lua_copy_sources

	use php && php-ext-source-r3_src_prepare
}

lua_src_configure() {
	pushd "${BUILD_DIR}" > /dev/null || die

	econf \
		--with-lua="${ELUA}" \
		--without-perl \
		--without-php \
		--without-python \
		--without-ruby

	popd > /dev/null || die
}

src_configure() {
	if use perl || use python || use ruby ; then
		econf \
			$(use_with lua) \
			$(use_with perl) \
			$(use_with python) \
			--without-php \
			$(use_with ruby)
	fi

	if use lua; then
		lua_foreach_impl lua_src_configure
	fi

	use php && php-ext-source-r3_src_configure
}

lua_src_compile() {
	pushd "${BUILD_DIR}" > /dev/null || die

	default_src_compile

	popd > /dev/null || die
}

src_compile() {
	if use perl || use python || use ruby ; then
		default
	fi

	if use lua; then
		lua_foreach_impl lua_src_compile
	fi

	use php && php-ext-source-r3_src_compile
}

lua_src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die

	default_src_test

	popd > /dev/null || die
}

src_test() {
	if use perl || use python || use ruby ; then
		default
	fi

	if use lua; then
		lua_foreach_impl lua_src_test
	fi

	if use php ; then
		local slot
		for slot in $(php_get_slots) ; do
			php_init_slot_env "${slot}"
			cd php || die
			${PHPCLI} -v
			${PHPCLI} -d "extension=./${PHP_EXT_NAME}.so" -f test.php || die "PHP tests for ${slot} failed!"
			cd "${S}" || die
		done
	fi
}

lua_src_install() {
	pushd "${BUILD_DIR}" > /dev/null || die

	emake DESTDIR="${D}" INSTALLDIRS=vendor luadir="$(lua_get_cmod_dir)" install

	popd > /dev/null || die
}

src_install() {
	if use perl || use python || use ruby ; then
		emake DESTDIR="${D}" INSTALLDIRS=vendor install
	fi

	if use lua; then
		lua_foreach_impl lua_src_install
	fi

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -delete
		find "${ED}" -depth -mindepth 1 -type d -empty -delete
	fi

	use python && python_optimize

	if use php; then
		local slot
		for slot in $(php_get_slots); do
			php_init_slot_env "${slot}"
			exeinto "${EXT_DIR#$EPREFIX}"
			doexe "php/${PHP_EXT_NAME}.so"
		done

		php-ext-source-r3_createinifiles
	fi

	local DOCS=( AUTHORS ChangeLog NEWS README TODO )
	local HTML_DOCS=( {NEWS,README,RELEASE,TODO}.html )
	einstalldocs
}
