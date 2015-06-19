# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/pecl-pam/pecl-pam-1.0.3-r1.ebuild,v 1.1 2014/09/30 23:03:47 grknight Exp $

EAPI=5

PHP_EXT_NAME="pam"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-pecl-r2 pam

KEYWORDS="~amd64 ~x86"

DESCRIPTION="This extension provides PAM (Pluggable Authentication Modules) integration"
LICENSE="PHP-2.02"
SLOT="0"
IUSE="debug"

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

src_configure() {
	my_conf="--with-pam=/usr $(use_enable debug)"
	php-ext-source-r2_src_configure
}

src_install() {
	pamd_mimic_system php auth account password
	php-ext-pecl-r2_src_install
}
