# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit autotools eutils python-single-r1 python-utils-r1

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="http://trac.osgeo.org/geos/"
SRC_URI="http://download.osgeo.org/geos/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 ~x86 ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc php python ruby static-libs"

RDEPEND="
	php? ( >=dev-lang/php-5.3:* )
	ruby? ( dev-lang/ruby:* )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	php? ( dev-lang/swig )
	python? ( dev-lang/swig ${PYTHON_DEPS} )
	ruby? ( dev-lang/swig )
"

src_prepare() {
	epatch "${FILESDIR}"/3.4.2-solaris-isnan.patch
	eautoreconf
	echo "#!${EPREFIX}/bin/bash" > py-compile
}

src_configure() {
	econf \
		$(use_enable python) \
		$(use_enable ruby) \
		$(use_enable php) \
		$(use_enable static-libs static)
}

src_compile() {
	emake

	use doc && emake -C "${S}/doc" doxygen-html
}

src_install() {
	emake DESTDIR="${D}" install

	use doc && dohtml -r doc/doxygen_docs/html/*
	use python && python_optimize "${D}$(python_get_sitedir)"/geos/

	find "${ED}" -name '*.la' -exec rm -f {} +
}
