# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="apcu"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="NOTICE README.md TECHNOTES.txt TODO"

# Define 5.6 here so we get the USE and REQUIRED_USE from the eclass
# This allows us to depend on the other slot
USE_PHP="php5-6 php7-0"

inherit php-ext-pecl-r2 confutils

# However, we only really build for 7.0; so redefine it here
USE_PHP="php7-0"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Stripped down version of APC supporting only user cache"
LICENSE="PHP-3.01"
SLOT="7"
IUSE="+mmap"

DEPEND=""
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-apcu:0[php_targets_php5-6] )"

LOCKS="pthreadmutex pthreadrw spinlock semaphore"

LUSE=""
for l in ${LOCKS}; do
	LUSE+="lock_${l} "
done

IUSE+=" ${LUSE/lock_pthreadrw/+lock_pthreadrw}"

REQUIRED_USE="^^ ( $LUSE )"

src_configure() {
	my_conf="--enable-apcu"
	use mmap || my_conf+=" --disable-apcu-mmap"

	enable_extension_enable "apcu-rwlocks" "lock_pthreadrw" 0

	php-ext-source-r2_src_configure
}

src_install() {
	if use php_targets_php7-0 ; then
		php-ext-pecl-r2_src_install

		insinto /usr/share/php7/apcu
		doins apc.php
	fi
}

pkg_postinst() {
	if use php_targets_php7-0 ; then
		elog "The apc.php file shipped with this release of pecl-apcu was"
		elog "installed into ${EPREFIX}/usr/share/php7/apcu/."
		elog
		elog "If you depend on the apc_* functions,"
		elog "please install dev-php/pecl-apcu_bc as this extension no longer"
		elog "provides backwards compatibility."
	fi
}
