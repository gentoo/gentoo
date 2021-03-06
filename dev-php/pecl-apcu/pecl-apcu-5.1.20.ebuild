# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="apcu"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( NOTICE README.md TECHNOTES.txt )

USE_PHP="php7-2 php7-3 php7-4 php8-0"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~arm64 ~x86"

DESCRIPTION="Stripped down version of APC supporting only user cache"
LICENSE="PHP-3.01"
SLOT="7"

LOCKS="pthreadmutex pthreadrw spinlock semaphore"

LUSE=""
for l in ${LOCKS}; do
	LUSE+="lock-${l} "
done

IUSE="+mmap ${LUSE/lock-pthreadrw/+lock-pthreadrw}"

REQUIRED_USE="^^ ( $LUSE )"

src_prepare() {
	php-ext-source-r3_src_prepare
	# Remove broken tests from php 7.4 due to trivial output differences
	if use php_targets_php7-4 ; then
		php_init_slot_env "php7.4"
		rm "${PHP_EXT_S}"/tests/apc_entry_00{2,3}.phpt || die
	fi
}

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-apcu
		$(use_enable mmap apcu-mmap)
		$(use_enable lock-spinlock apcu-spinlocks)
	)
	# Broken upstream autoconf test disables if present at all
	use lock-pthreadrw || PHP_EXT_ECONF_ARGS+=( --disable-apcu-rwlocks )

	php-ext-source-r3_src_configure
}

src_install() {
	php-ext-pecl-r3_src_install

	insinto /usr/share/php7/apcu
	doins apc.php
}

pkg_postinst() {
	elog "The apc.php file shipped with this release of pecl-apcu was"
	elog "installed to ${EPREFIX}/usr/share/php7/apcu/."
	elog
	elog "If you depend on the apc_* functions,"
	elog "please install dev-php/pecl-apcu_bc as this extension no longer"
	elog "provides backwards compatibility."
}
