# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'
inherit python-any-r1 waf-utils

DESCRIPTION="Library for storing RDF data in memory"
HOMEPAGE="http://drobilla.net/software/sord/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc static-libs test"

RDEPEND=">=dev-libs/serd-0.22.4"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( "AUTHORS" "NEWS" "README" )

src_prepare() {
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
}

src_configure() {
	waf-utils_src_configure \
		--docdir=/usr/share/doc/${PF} \
		$(use test && echo "--test") \
		$(use doc && echo "--docs") \
		$(use static-libs && echo "--static")
}

src_test() {
	./waf test || die
}
