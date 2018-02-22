# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils multilib-build multilib-minimal

DESCRIPTION="A simple but extensible successor of LADSPA"
HOMEPAGE="http://lv2plug.in/"
SRC_URI="http://lv2plug.in/spec/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~ppc64 ~x86"
IUSE="doc plugins"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	plugins? ( x11-libs/gtk+:2 media-libs/libsndfile )"
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

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	waf-utils_src_configure \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--lv2dir="${EPREFIX}"/usr/$(get_libdir)/lv2 \
		$(use plugins || echo " --no-plugins") \
		$(multilib_native_usex doc --docs "")
}

multilib_src_install() {
	waf-utils_src_install
}

multilib_src_install_all() {
	python_fix_shebang "${D}"
}
