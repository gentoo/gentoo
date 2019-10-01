# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="apcu"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( NOTICE README.md TECHNOTES.txt TODO )

USE_PHP="php5-6 php7-1 php7-2 php7-3"

inherit php-ext-pecl-r3

USE_PHP="php5-6"

KEYWORDS="amd64 ~arm64 x86"

DESCRIPTION="Stripped down version of APC supporting only user cache"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="+mmap"

DEPEND=""
PDEPEND="
php_targets_php7-1? ( dev-php/pecl-apcu:7[php_targets_php7-1] )
php_targets_php7-2? ( dev-php/pecl-apcu:7[php_targets_php7-2] )
php_targets_php7-3? ( dev-php/pecl-apcu:7[php_targets_php7-3] )
"

LOCKS="pthreadmutex pthreadrw spinlock semaphore"

LUSE=""
for l in ${LOCKS}; do
	LUSE+="lock-${l} "
done

IUSE+=" ${LUSE/lock-pthreadrw/+lock-pthreadrw}"

REQUIRED_USE="^^ ( $LUSE )"

src_prepare() {
	if use php_targets_php5-6 ; then
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php5-6 ; then
		local PHP_EXT_ECONF_ARGS=(
			--enable-apcu
			$(use_enable mmap apcu-mmap)
			$(use_enable lock-pthreadrw apcu-rwlocks)
			$(use_enable lock-spinlock apcu-spinlocks)
		)

		php-ext-source-r3_src_configure
	fi
}

src_install() {
	if use php_targets_php5-6 ; then
		php-ext-pecl-r3_src_install

		insinto "${PHP_EXT_SHARED_DIR#$EPREFIX}"
		doins apc.php
	fi
}

pkg_postinst() {
	if use php_targets_php5-6 ; then
		elog "The apc.php file shipped with this release of pecl-apcu was"
		elog "installed into ${PHP_EXT_SHARED_DIR}."
	fi
}
