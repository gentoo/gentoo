# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="libvirt-php"
PHP_EXT_SKIP_PHPIZE="yes"
USE_PHP="php8-1"
PHP_EXT_ECONF_ARGS=()

inherit php-ext-source-r3 autotools

DESCRIPTION="PHP bindings for libvirt"
HOMEPAGE="http://libvirt.org/php/"
SRC_URI="http://libvirt.org/sources/php/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="app-emulation/libvirt
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig
	doc? ( app-text/xhtml1 )"

DOCS=( ChangeLog NEWS README )

src_unpack() {
	default

	# create the default modules directory to be able
	# to use the php-ext-source-r3 eclass to configure/build
	ln -s src "${S}/modules" || die
}

src_prepare() {
	php-ext-source-r3_src_prepare

	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		eautoreconf
	done
}

src_install() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		insinto "${EXT_DIR}"
		doins "src/.libs/${PHP_EXT_NAME}.so"
	done

	php-ext-source-r3_createinifiles
	einstalldocs

	if use doc ; then
		docinto html
		dodoc -r docs/*
	fi
}

src_test() {
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		default
	done
}
