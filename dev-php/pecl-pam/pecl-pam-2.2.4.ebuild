# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="pam"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHP_EXT_ECONF_ARGS=( --with-pam=/usr )
DOCS=( README )

USE_PHP="php8-1"

inherit php-ext-pecl-r3 pam

KEYWORDS="~amd64 ~x86"

DESCRIPTION="This extension provides PAM (Pluggable Authentication Modules) integration"
LICENSE="PHP-3.01"
SLOT="0"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

src_prepare() {
	#Fix DOS line endings
	sed -i 's/\r$//' -- pam.c || die
	php-ext-source-r3_src_prepare
}

src_install() {
	pamd_mimic_system php auth account password
	php-ext-pecl-r3_src_install
}
