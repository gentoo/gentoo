# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE='threads(+)'
inherit python-single-r1 waf-utils multilib

DESCRIPTION="A simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
SRC_URI="http://lv2plug.in/spec/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc plugins"

DEPEND="plugins? ( x11-libs/gtk+:2 media-libs/libsndfile )"
RDEPEND="${DEPEND}
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
	!<media-libs/slv2-0.4.2
	!media-libs/lv2core
	!media-libs/lv2-ui"
DEPEND="${DEPEND}
	plugins? ( virtual/pkgconfig )
	doc? ( app-doc/doxygen dev-python/rdflib )"
DOCS=( "README.md" "NEWS" )

src_configure() {
	waf-utils_src_configure \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--lv2dir="${EPREFIX}"/usr/$(get_libdir)/lv2 \
		$(use plugins || echo " --no-plugins") \
		$(use doc     && echo " --docs"      )
}

src_install() {
	waf-utils_src_install

	python_fix_shebang "${D}"
}
