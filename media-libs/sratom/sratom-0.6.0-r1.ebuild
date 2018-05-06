# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'
inherit python-any-r1 waf-utils multilib-build multilib-minimal

DESCRIPTION="Library for serialising LV2 atoms to/from RDF, particularly the Turtle syntax"
HOMEPAGE="http://drobilla.net/software/sratom/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~x86"
IUSE="doc static-libs test"

RDEPEND=">=media-libs/lv2-1.14.0-r1
	>=dev-libs/serd-0.28.0-r1
	>=dev-libs/sord-0.16.0-r1"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig"

DOCS=( "NEWS" "README" )

src_prepare() {
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	default
	multilib_copy_sources
}

multilib_src_configure() {
	waf-utils_src_configure \
		--docdir=/usr/share/doc/${PF} \
		$(multilib_native_usex doc --docs "") \
		$(usex test --test "") \
		$(usex static-libs --static "")
}

multilib_src_test() {
	./waf test || die
}

multilib_src_compile() {
	waf-utils_src_compile
	default
}

multilib_src_install() {
	waf-utils_src_install
	default
}
