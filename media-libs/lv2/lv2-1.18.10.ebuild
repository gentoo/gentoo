# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE='threads(+)'

inherit meson-multilib python-single-r1

DESCRIPTION="A simple but extensible successor of LADSPA"
HOMEPAGE="https://lv2plug.in/"
SRC_URI="https://lv2plug.in/spec/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc plugins"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	plugins? ( virtual/pkgconfig )
	doc? (
		app-doc/doxygen
		dev-python/rdflib
	)
"
CDEPEND="
	${PYTHON_DEPS}
	plugins? (
		media-libs/libsamplerate
		media-libs/libsndfile
		x11-libs/gtk+:2
	)
"
DEPEND="
	${CDEPEND}
	doc? ( dev-python/markdown )
"
RDEPEND="
	${CDEPEND}
	$(python_gen_cond_dep '
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/rdflib[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${PN}-1.18.6-add-missing-lv2.h.patch"
)

src_prepare() {
	default

	# fix doc installation path
	sed -iE "s%lv2_docdir = .*%lv2_docdir = '"${EPREFIX}"/usr/share/doc/${PF}'%g" meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		-Dlv2dir="${EPREFIX}"/usr/$(get_libdir)/lv2
		$(meson_native_use_feature doc docs)
		$(meson_feature plugins)
	)

	meson_src_configure
}

multilib_src_install_all() {
	local DOCS=( NEWS README.md )
	einstalldocs
}
