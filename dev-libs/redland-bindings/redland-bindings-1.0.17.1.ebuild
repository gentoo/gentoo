# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 python3_7 python3_8 )

USE_PHP="php7-2 php7-3 php7-4"
PHP_EXT_NAME="redland"
PHP_EXT_OPTIONAL_USE="php"
PHP_EXT_SKIP_PHPIZE="yes"

inherit php-ext-source-r3 python-single-r1 autotools

DESCRIPTION="Language bindings for Redland"
HOMEPAGE="http://librdf.org/bindings/"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-linux ~ppc-macos"
IUSE="lua perl python php ruby"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/redland-1.0.14
	lua? ( >=dev-lang/lua-5.1 )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby dev-ruby/log4r )
	php? (
		php_targets_php7-2? ( dev-lang/php:7.2[-threads] )
		php_targets_php7-3? ( dev-lang/php:7.3[-threads] )
		php_targets_php7-4? ( dev-lang/php:7.4[-threads] )
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-lang/swig-2
	sys-apps/sed"

PATCHES=( "${FILESDIR}/${P}-bool.patch" )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	if use php ; then
		local slot
		for slot in $(php_get_slots); do
			php_init_slot_env "${slot}"
			eapply "${FILESDIR}/${P}-php-config.patch"
			eautoreconf
		done
	fi
}

src_configure() {
	if use lua || use perl || use python || use ruby ; then
		econf \
			$(use_with lua) \
			$(use_with perl) \
			$(use_with python) \
			--without-php \
			$(use_with ruby)
	fi

	if use php ; then
		local slot
		for slot in $(php_get_slots); do
			php_init_slot_env "${slot}"
			econf --with-php="${PHP_CURRENTSLOT}" \
				--with-php-config="${PHPPREFIX}/bin" \
				--without-lua --without-perl \
				--without-python --without-ruby
		done
	fi
}

src_compile() {
	if use lua || use perl || use python || use ruby ; then
		default
	fi
	use php && php-ext-source-r3_src_compile
}

src_install() {
	if use lua || use perl || use python || use ruby ; then
		emake DESTDIR="${D}" INSTALLDIRS=vendor luadir=/usr/$(get_libdir)/lua/5.1 install
	fi

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -delete
		find "${ED}" -depth -mindepth 1 -type d -empty -delete
	fi
	use python && python_optimize

	if use php ; then
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
