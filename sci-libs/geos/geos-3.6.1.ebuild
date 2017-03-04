# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="Geometry engine library for Geographic Information Systems"
HOMEPAGE="http://trac.osgeo.org/geos/"
SRC_URI="http://download.osgeo.org/geos/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="doc python ruby static-libs"

RDEPEND="
	python? ( ${PYTHON_DEPS} )
	ruby? ( dev-lang/ruby:* )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig:0 )
	ruby? ( dev-lang/swig:0 )
"

PATCHES=( "${FILESDIR}"/3.4.2-solaris-isnan.patch )

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	echo "#!${EPREFIX}/bin/bash" > py-compile
}

src_configure() {
	econf \
		$(use_enable python) \
		$(use_enable ruby) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	use doc && emake -C "${S}/doc" doxygen-html
}

src_install() {
	use doc && HTML_DOCS=( doc/doxygen_docs/html/. )
	default
	use python && python_optimize "${D}$(python_get_sitedir)"/geos/

	find "${D}" -name '*.la' -delete || die
}
