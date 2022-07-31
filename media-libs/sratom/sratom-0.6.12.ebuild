# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE='threads(+)'
inherit meson-multilib python-any-r1

DESCRIPTION="Library for serialising LV2 atoms to/from RDF, particularly the Turtle syntax"
HOMEPAGE="http://drobilla.net/software/sratom/"
SRC_URI="http://download.drobilla.net/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		dev-python/sphinx_lv2_theme
)
"
RDEPEND="
	dev-libs/serd
	dev-libs/sord
	media-libs/lv2
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
"

src_prepare() {
	default

	# fix doc installation path
	sed -iE "s%install_dir: docdir / 'sratom-0',%install_dir: docdir / '${PF}',%g" doc/c/meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature doc docs)
		$(meson_feature test tests)
	)

	meson_src_configure
}

multilib_src_test() {
	meson_src_test
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

mutlilib_src_install_all() {
	local DOCS=( NEWS README.md )
	einstalldocs
}
