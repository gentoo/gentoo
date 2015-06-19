# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-memcached/pecl-memcached-2.2.0.ebuild,v 1.2 2015/01/12 15:39:35 grknight Exp $

EAPI="4"
PHP_EXT_NAME="memcached"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php5-5 php5-6 php5-4"

inherit base php-ext-pecl-r2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension for interfacing with memcached via libmemcached library"
LICENSE="PHP-3"
SLOT="0"
IUSE="+session igbinary json sasl"

DEPEND="|| ( >=dev-libs/libmemcached-1.0.14 >=dev-libs/libmemcached-1.0[sasl?] )
		sys-libs/zlib
		dev-lang/php[session?,json?]
		igbinary? ( dev-php/igbinary[php_targets_php5-5?,php_targets_php5-4?,php_targets_php5-6?] )"
RDEPEND="${DEPEND}"

src_prepare() {
	local slot orig_s="${S}"
	for slot in $(php_get_slots); do
		export S="${WORKDIR}/${slot}"
		cd "${S}"
		base_src_prepare
	done
	export S="${orig_s}"
	cd "${S}"
	php-ext-source-r2_src_prepare
}

src_configure() {
	my_conf="--enable-memcached
		$(use_enable session memcached-session)
		$(use_enable sasl memcached-sasl)
		$(use_enable json memcached-json)
		$(use_enable igbinary memcached-igbinary)"

	php-ext-source-r2_src_configure
}
