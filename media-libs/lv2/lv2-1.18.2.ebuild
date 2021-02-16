# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils multilib-build multilib-minimal

DESCRIPTION="A simple but extensible successor of LADSPA"
HOMEPAGE="https://lv2plug.in/"
SRC_URI="https://lv2plug.in/spec/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86"
IUSE="doc plugins"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	plugins? ( virtual/pkgconfig )
	doc? ( app-doc/doxygen dev-python/rdflib )
"
CDEPEND="
	${PYTHON_DEPS}
	plugins? ( x11-libs/gtk+:2 media-libs/libsndfile )
"
DEPEND="
	${CDEPEND}
	doc? ( dev-python/markdown )
"
RDEPEND="
	${CDEPEND}
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_MULTI_USEDEP}]
		dev-python/pygments[${PYTHON_MULTI_USEDEP}]
		dev-python/rdflib[${PYTHON_MULTI_USEDEP}]
	')
"
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
