# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PHP_EXT_NAME="libvirt-php"
PHP_EXT_SKIP_PHPIZE="yes"
USE_PHP="php7-4 php8-0 php8-1"
PHP_EXT_ECONF_ARGS=()
SNAPSHOT="23dde4ddc42fabee0b8c6625b80183b3cbe96a67"

inherit php-ext-source-r3 autotools

DESCRIPTION="PHP bindings for libvirt"
HOMEPAGE="http://libvirt.org/php/"
SRC_URI="https://gitlab.com/libvirt/${PN}/-/archive/${SNAPSHOT}/${PN}-${SNAPSHOT}.tar.bz2 -> ${P}.tar.bz2"

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

S="${WORKDIR}/${PN}-${SNAPSHOT}"
PHP_EXT_S="${S}"

DOCS=( ChangeLog NEWS README )
# Remove the insane check for pecl-imagick which is only used in examples
# and is not called upon in any build
PATCHES=( "${FILESDIR}/remove-imagick-check.patch" )

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
