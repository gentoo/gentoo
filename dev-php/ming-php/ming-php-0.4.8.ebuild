# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME=ming
MY_P="${PHP_EXT_NAME}-${PV//./_}"
USE_PHP="php5-6 php7-0 php7-1 php7-2"
PHP_EXT_S="${WORKDIR}/libming-${MY_P}/php_ext"
inherit flag-o-matic php-ext-source-r3

DESCRIPTION="PHP extension for the ming Flash movie generation library"
HOMEPAGE="http://ming.sourceforge.net/"
SRC_URI="https://github.com/libming/libming/archive/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/ming"
DEPEND="${RDEPEND}"

S="${WORKDIR}/libming-${MY_P}"
# Clear out near-empty README files which are not helpful to the user
DOCS=( )

src_prepare() {
	local libdir=$(get_libdir)
	cp "${FILESDIR}/php_ext-config.m4" "${PHP_EXT_S}/config.m4" || \
		die "Failed to copy config.m4 to target"
	rm "${PHP_EXT_S}/Makefile.am" || die "Failed to remove Makefile.am for ${slot}"
	# Fix for SYMYLINK_LIB=no
	if [[ ${libdir} != 'lib' ]] ; then
		sed -i -e "s~PHP_LIBDIR=lib~PHP_LIBDIR=${libdir}~" "${PHP_EXT_S}/config.m4" \
			|| die "Failed to update lib directory"
	fi
	php-ext-source-r3_src_prepare
}

src_configure() {
	# build is sensitive to -O3 (bug #297437)
	replace-flags -O3 -O2

	local PHP_EXT_EXTRA_ECONF="--with-ming=${S}"
	php-ext-source-r3_src_configure
}
