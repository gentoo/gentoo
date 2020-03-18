# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="apcu"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS=( NOTICE README.md TECHNOTES.txt TODO )

# Define 5.6 here so we get the USE and REQUIRED_USE from the eclass
# This allows us to depend on the other slot
USE_PHP="php5-6 php7-0 php7-1 php7-2 php7-3"

inherit php-ext-pecl-r3

# However, we only really build for 7.x; so redefine it here
USE_PHP="php7-0 php7-1 php7-2 php7-3"

KEYWORDS="amd64 x86"

DESCRIPTION="Stripped down version of APC supporting only user cache"
LICENSE="PHP-3.01"
SLOT="7"
IUSE="+mmap"

DEPEND=""
RDEPEND="${DEPEND} php_targets_php5-6? ( dev-php/pecl-apcu:0[php_targets_php5-6] )"

LOCKS="pthreadmutex pthreadrw spinlock semaphore"

LUSE=""
for l in ${LOCKS}; do
	LUSE+="lock-${l} "
done

IUSE+=" ${LUSE/lock-pthreadrw/+lock-pthreadrw}"

REQUIRED_USE="^^ ( $LUSE )"

src_prepare() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 ; then
		php-ext-source-r3_src_prepare
	else
		eapply_user
	fi
}

src_configure() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 ; then
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
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 ; then
		php-ext-pecl-r3_src_install

		insinto /usr/share/php7/apcu
		doins apc.php
	fi
}

pkg_postinst() {
	if use php_targets_php7-0 || use php_targets_php7-1 || use php_targets_php7-2 || use php_targets_php7-3 ; then
		elog "The apc.php file shipped with this release of pecl-apcu was"
		elog "installed to ${EPREFIX}/usr/share/php7/apcu/."
		elog
		elog "If you depend on the apc_* functions,"
		elog "please install dev-php/pecl-apcu_bc as this extension no longer"
		elog "provides backwards compatibility."
	fi
}
