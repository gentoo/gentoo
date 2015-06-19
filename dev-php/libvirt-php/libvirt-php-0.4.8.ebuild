# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/libvirt-php/libvirt-php-0.4.8.ebuild,v 1.1 2014/10/02 13:50:42 grknight Exp $

EAPI=5

PHP_EXT_NAME="libvirt-php"
PHP_EXT_SKIP_PHPIZE="yes"
USE_PHP="php5-6 php5-5 php5-4"

inherit php-ext-source-r2 eutils

DESCRIPTION="PHP 5 bindings for libvirt"
HOMEPAGE="http://libvirt.org/php/"
SRC_URI="http://libvirt.org/sources/php/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="app-emulation/libvirt
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	doc? ( app-text/xhtml1 )"

RESTRICT="test"

src_unpack() {
	default
	# create the default modules directory to be able
	# to use the php-ext-source-r2 eclass to configure/build
	ln -s src "${S}/modules"

	for slot in $(php_get_slots); do
		cp -r "${S}" "${WORKDIR}/${slot}"
	done
}

src_install() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		insinto "${EXT_DIR}"
		newins "src/${PHP_EXT_NAME}.so" "${PHP_EXT_NAME}.so"
	done
	php-ext-source-r2_createinifiles
	dodoc AUTHORS ChangeLog NEWS README
	use doc && dohtml docs/* docs/graphics/*
}
