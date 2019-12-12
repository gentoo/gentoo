# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_INI_NAME="bc_apc"
PHP_EXT_NAME="apc"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_EXTRA_ECONF=""
DOCS=( README.md )

USE_PHP="php7-1 php7-2 php7-3 php7-4"

inherit php-ext-pecl-r3 multilib

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Provides APC backwards compatibility functions via APCu"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND=">=dev-php/pecl-apcu-5.1.18:7[php_targets_php7-1?,php_targets_php7-2?,php_targets_php7-3?,php_targets_php7-4?]"
RDEPEND="${DEPEND}"

src_test() {
	# This fixed version is necessary to have apcu load
	# from the install before the tested apc.
	# It is intentional to specify phpoptions twice.
	# This mimics the Makefile.
	local slot phpoptions
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		ln -s "${EXT_DIR}/apcu$(get_libname)" \
			"modules/" || die
		phpoptions=( -n -d extension_dir="${PHP_EXT_S}/modules"
			-d extension=apcu$(get_libname)
			-d extension=apc$(get_libname)  )
		NO_INTERACTION="yes" TEST_PHP_EXECUTABLE="${PHPCLI}" \
			"${PHPCLI}" "${phpoptions[@]}" \
			run-tests.php "${phpoptions[@]}" || die
	done
}
