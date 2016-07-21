# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME=ming
MY_P="${PHP_EXT_NAME}-${PV}"
USE_PHP="php5-4 php5-5 php5-6"
PHP_EXT_S="${MY_P}/php_ext"
inherit flag-o-matic php-ext-source-r2

DESCRIPTION="PHP extension for the ming Flash movie generation library"
HOMEPAGE="http://ming.sourceforge.net/"
SRC_URI="mirror://sourceforge/ming/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ~ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/ming"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		cp "${FILESDIR}/php_ext-config.m4" "${WORKDIR}/${slot}/config.m4" || \
			die "Failed to copy config.m4 to target"
		rm "${WORKDIR}/${slot}/Makefile.am" || die "Failed to remove Makefile.am for ${slot}"
		php_init_slot_env ${slot}
		epatch "${FILESDIR}/ming-php-54.patch"
		php-ext-source-r2_phpize
	done
}

src_configure() {
	# build is sensitive to -O3 (bug #297437)
	replace-flags -O3 -O2

	local my_conf="--with-ming=${S}"
	php-ext-source-r2_src_configure
}
