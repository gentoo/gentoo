# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit xdg-utils meson-multilib python-any-r1

DESCRIPTION="A thin layer of types for graphic libraries"
HOMEPAGE="https://ebassi.github.io/graphene/"
SRC_URI="https://github.com/ebassi/graphene/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse2 doc +introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.30.0:2[${MULTILIB_USEDEP}]
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
# Python is only needed with USE=introspection or FEATURES=test, but not bothering with conditional python_setup, as meson uses it too anyway
BDEPEND="
	${PYTHON_DEPS}
	doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3
	)
	virtual/pkgconfig
"

multilib_src_configure() {
	# TODO: Do we want G_DISABLE_ASSERT as buildtype=release would do upstream?
	local emesonargs=(
		$(meson_native_use_bool doc gtk_doc)
		-Dgobject_types=true
		$(meson_native_use_feature introspection)
		-Dgcc_vector=true # if built-in support tests fail, it'll just not enable vector intrinsics; unfortunately this probably means disabled on clang too, due to it claiming to be <gcc-4.9
		$(meson_use cpu_flags_x86_sse2 sse2)
		$(meson_use cpu_flags_arm_neon arm_neon)
		$(meson_use test tests)
		-Dinstalled_tests=false
	)
	meson_src_configure
}
