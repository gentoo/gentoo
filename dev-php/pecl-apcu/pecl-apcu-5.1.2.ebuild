# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME="apcu"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="NOTICE README.md TECHNOTES.txt TODO"

USE_PHP="php7-0"

inherit php-ext-pecl-r2 confutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Stripped down version of APC supporting only user cache"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="+mmap"

DEPEND=""
RDEPEND="${DEPEND}"

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
	php-ext-pecl-r2_src_install

	insinto "${PHP_EXT_SHARED_DIR}"
	doins apc.php
}

pkg_postinst() {
	elog "The apc.php file shipped with this release of pecl-apcu was"
	elog "installed into ${PHP_EXT_SHARED_DIR}/."
	elog
	elog "If you depend on the apc_* functions,"
	elog "please install dev-php/pecl-apcu_bc as this extension no longer"
	elog "provides backwards compatibility."
}
