# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PHP_EXT_NAME=ming
PHP_EXT_OPTIONAL_USE=php
USE_PHP="php5-3"
PYTHON_DEPEND="python? 2"
AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils flag-o-matic multilib php-ext-source-r2 perl-module python

DESCRIPTION="An Open Source library for Flash movie generation"
HOMEPAGE="http://ming.sourceforge.net/"
SRC_URI="mirror://sourceforge/ming/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+perl +python php static-libs"

RDEPEND="perl? ( dev-lang/perl )
	python? ( dev-lang/python )
	media-libs/freetype
	media-libs/libpng
	media-libs/giflib
	sys-libs/zlib
	!media-libs/libswf"
DEPEND="${DEPEND}
	sys-devel/flex
	virtual/yacc"

S=${WORKDIR}/${P/_/.}

# Tests only work when the package is tested on a system
# which does not presently have any version of ming installed.
RESTRICT="test"

pkg_setup() {
	use python && python_set_active_version 2 && python_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/${P}-vasprintf.patch
	"${FILESDIR}"/${PN}-0.4.3-perl-5.14.patch )

src_prepare() {
	# Let's get rid of the TEXTRELS, link dynamic. Use gif.
	sed -i \
		-e 's/libming.a/libming.so/' \
		-e 's/lungif/lgif/' \
		perl_ext/Makefile.PL
	sed -i \
		-e 's/ungif/gif/' \
		py_ext/setup.py.in

	if use php; then
		cd "${S}/php_ext"
		php-ext-source-r2_phpize
		cd "${S}"
	fi

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die

	autotools-utils_src_prepare
}

src_configure() {
	# build is sensitive to -O3 (bug #297437)
	replace-flags -O3 -O2

	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable perl)
		$(use_enable python)
		)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use php; then
		cd "${S}"/php_ext
		myconf="--disable-rpath
			--disable-static
			--with-ming"
		php-ext-source-r2_src_compile
	fi
}

src_install() {
	autotools-utils_src_install INSTALLDIRS="vendor"

	perl_delete_localpod

	use python && python_clean_installation_image

	if use php; then
		cd "${S}"/php_ext
		php-ext-source-r2_src_install
	fi
}

pkg_postinst() {
	use python && python_mod_optimize ming.py mingc.py
}

pkg_prerm() {
	:
}

pkg_postrm() {
	use python && python_mod_cleanup ming.py mingc.py
}
