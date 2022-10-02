# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="Library for RDF syntax which supports reading and writing Turtle and NTriples"
HOMEPAGE="https://drobilla.net/software/serd.html"
SRC_URI="http://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc static-libs test +tools"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		dev-python/sphinx_lv2_theme
)
"

src_prepare() {
	default

	# fix doc installation path
	sed -i "s/versioned_name/'${PF}'/g" doc/c/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature doc docs)
		$(meson_use static-libs static)
		$(meson_feature test tests)
		$(meson_feature tools)
	)

	meson_src_configure
}

multilib_src_install_all() {
	local DOCS=( AUTHORS NEWS README.md )
	einstalldocs
}
