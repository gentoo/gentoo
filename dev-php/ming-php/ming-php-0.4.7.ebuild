# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME=ming
MY_P="${PHP_EXT_NAME}-${PV//./_}"
USE_PHP="php5-6"
PHP_EXT_S="libming-${MY_P}/php_ext"
inherit flag-o-matic php-ext-source-r3

DESCRIPTION="PHP extension for the ming Flash movie generation library"
HOMEPAGE="http://ming.sourceforge.net/"
SRC_URI="https://github.com/libming/libming/archive/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/ming"
DEPEND="${RDEPEND}"

S="${WORKDIR}/libming-${MY_P}"

src_prepare() {
	local slot orig_s="${PHP_EXT_S}"
	for slot in $(php_get_slots); do
		cp "${FILESDIR}/php_ext-config.m4" "${WORKDIR}/${slot}/config.m4" || \
			die "Failed to copy config.m4 to target"
		rm "${WORKDIR}/${slot}/Makefile.am" || die "Failed to remove Makefile.am for ${slot}"
		php_init_slot_env ${slot}
		eapply -p0 "${FILESDIR}/ming-php-54.patch"
		eapply_user
		php-ext-source-r3_phpize
	done
}

src_configure() {
	# build is sensitive to -O3 (bug #297437)
	replace-flags -O3 -O2

	local PHP_EXT_EXTRA_ECONF="--with-ming=${S}"
	php-ext-source-r3_src_configure
}
