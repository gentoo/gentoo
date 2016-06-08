# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
PHP_EXT_NAME=ming
PHP_EXT_OPTIONAL_USE=php
AUTOTOOLS_AUTORECONF=yes
GENTOO_DEPEND_ON_PERL=no
inherit autotools distutils-r1 flag-o-matic multilib perl-module vcs-snapshot

DESCRIPTION="An Open Source library for Flash movie generation"
HOMEPAGE="http://ming.sourceforge.net/"
SRC_URI="https://github.com/libming/libming/archive/${P//./_}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+perl php +python static-libs"

RDEPEND="perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	media-libs/freetype:=
	media-libs/libpng:0=
	media-libs/giflib:=
	sys-libs/zlib:=
	!media-libs/libswf"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc"
PDEPEND="php? ( dev-php/ming-php )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
S=${WORKDIR}/${P//./_}

# Tests only work when the package is tested on a system
# which does not presently have any version of ming installed.
RESTRICT="test"

src_prepare() {
	default

	# Let's get rid of the TEXTRELS, link dynamic. Use gif.
	sed -i \
		-e 's/libming.a/libming.so/' \
		-e 's/lungif/lgif/' \
		perl_ext/Makefile.PL

	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.in || die

	eautoreconf
}

src_configure() {
	# build is sensitive to -O3 (bug #297437)
	replace-flags -O3 -O2

	# build python via distutils calls, disable here
	# php is done in dev-php/ming-php
	local myconf=(
		--disable-python
		--disable-php
		$(use_enable static-libs static)
		$(use_enable perl)
	)
	econf "${myconf[@]}"
}

run_distutils() {
	if use python; then
		pushd py_ext > /dev/null || die
		distutils-r1_"${@}"
		popd > /dev/null || die
	fi
}

src_compile() {
	# some parallel make issues on flex/bison
	emake -C src/actioncompiler -j1
	emake

	run_distutils ${FUNCNAME}
}

src_install() {
	run_distutils ${FUNCNAME}

	emake DESTDIR="${D}" INSTALLDIRS="vendor" install
	einstalldocs

	perl_delete_localpod
	find "${ED}"usr/lib* -name '*.la' -delete
}
