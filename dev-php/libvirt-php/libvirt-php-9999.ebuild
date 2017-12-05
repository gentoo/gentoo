# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="libvirt-php"
PHP_EXT_SKIP_PHPIZE="yes"
USE_PHP="php5-6 php7-0 php7-1"

inherit php-ext-source-r3 git-r3 autotools

DESCRIPTION="PHP bindings for libvirt"
HOMEPAGE="http://libvirt.org/php/"
EGIT_REPO_URI="git://libvirt.org/libvirt-php.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="app-emulation/libvirt
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig
	doc? ( app-text/xhtml1 )"

RESTRICT="test"
DOCS=( ChangeLog NEWS README )

src_unpack() {
	git-r3_src_unpack

	# create the default modules directory to be able
	# to use the php-ext-source-r3 eclass to configure/build
	ln -s src "${S}/modules"

	for slot in $(php_get_slots); do
		cp -r "${S}" "${WORKDIR}/${slot}"
	done
}

src_prepare() {
	# Remove the insane check for pecl-imagick which is only used in examples
	# and is not called upon in any build
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		eapply "${FILESDIR}/remove-imagick-check.patch"
		eapply_user
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
		docinto /usr/share/doc/${PF}/html
		dodoc -r docs/*
	fi
}
