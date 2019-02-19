# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6,7} )
inherit xdg-utils meson multilib-minimal python-any-r1

DESCRIPTION="A thin layer of types for graphic libraries"
HOMEPAGE="https://ebassi.github.io/graphene/"
SRC_URI="https://github.com/ebassi/graphene/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 ~sparc x86 ~amd64-fbsd"
IUSE="cpu_flags_arm_neon cpu_flags_x86_sse2 doc +introspection test"

RDEPEND="
	>=dev-libs/glib-2.30.0:2[${MULTILIB_USEDEP}]
	introspection? ( dev-libs/gobject-introspection:= )
"
# Python is only needed with USE=introspection or FEATURES=test, but not bothering with conditional python_setup
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( dev-util/gtk-doc )
	virtual/pkgconfig
"

src_prepare() {
	xdg_environment_reset
	default
	# Disable installed-tests
	sed -e 's/install: true/install: false/g' -i src/tests/meson.build || die
}

multilib_src_configure() {
	# TODO: Do we want G_DISABLE_ASSERT as buildtype=release would do upstream?
	local emesonargs=(
		-Dgtk_doc=$(multilib_native_usex doc true false)
		-Dgobject_types=true
		-Dintrospection=$(multilib_native_usex introspection true false)
		-Dgcc_vector=true # if built-in support tests fail, it'll just not enable vector intrinsics; unfortunately this probably means disabled on clang too, due to it claiming to be <gcc-4.9
		$(meson_use cpu_flags_x86_sse2 sse2)
		$(meson_use cpu_flags_arm_neon arm_neon)
		$(meson_use test tests)
		-Dbenchmarks=false
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}
