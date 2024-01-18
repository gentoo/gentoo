# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PHP_EXT_NAME="ps"
USE_PHP="php8-1"
PHP_EXT_NEEDED_USE="gd(-)?"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DESCRIPTION="PHP extension for creating PostScript files"
LICENSE="BSD"
SLOT="7"
IUSE="examples gd"

DEPEND="dev-libs/pslib gd? ( media-libs/gd:2= )"
RDEPEND="${DEPEND}"
PATCHES=( "${FILESDIR}/ps-1.4.4-fix-gd-detection.patch" )

src_configure() {
	PHP_EXT_ECONF_ARGS=( $(use_enable gd) )
	php-ext-source-r3_src_configure
}

src_test() {
	# tests/004.phpt depends on set numeric format
	LC_ALL=C php-ext-pecl-r3_src_test
}
