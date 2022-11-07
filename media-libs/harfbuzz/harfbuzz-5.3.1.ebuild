# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )

inherit flag-o-matic meson-multilib python-any-r1 xdg-utils

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/HarfBuzz"

if [[ ${PV} = 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/harfbuzz/harfbuzz.git"
	inherit git-r3
else
	SRC_URI="https://github.com/harfbuzz/harfbuzz/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="Old-MIT ISC icu"
# 0.9.18 introduced the harfbuzz-icu split; bug #472416
# 3.0.0 dropped some unstable APIs; bug #813705
SLOT="0/4.0.0"

IUSE="+cairo debug doc experimental +glib +graphite icu +introspection test +truetype"
RESTRICT="!test? ( test )"
REQUIRED_USE="introspection? ( glib )"

RDEPEND="
	cairo? ( x11-libs/cairo:= )
	glib? ( >=dev-libs/glib-2.38:2[${MULTILIB_USEDEP}] )
	graphite? ( >=media-gfx/graphite2-1.2.1:=[${MULTILIB_USEDEP}] )
	icu? ( >=dev-libs/icu-51.2-r1:=[${MULTILIB_USEDEP}] )
	introspection? ( >=dev-libs/gobject-introspection-1.34:= )
	truetype? ( >=media-libs/freetype-2.5.0.1:2=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-libs/gobject-introspection-common-1.34
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-util/glib-utils )
"

pkg_setup() {
	python-any-r1_pkg_setup
	if ! use debug ; then
		append-cppflags -DHB_NDEBUG
	fi
}

src_prepare() {
	default

	xdg_environment_reset

	# bug #726120
	sed -i \
		-e '/tests\/macos\.tests/d' \
		test/shape/data/in-house/Makefile.sources \
		|| die

	# bug #618772
	append-cxxflags -std=c++14

	# bug #790359
	filter-flags -fexceptions -fthreadsafe-statics

	# bug #762415
	local pyscript
	for pyscript in $(find -type f -name "*.py") ; do
		python_fix_shebang -q "${pyscript}"
	done
}

multilib_src_configure() {
	# harfbuzz-gobject only used for introspection, bug #535852
	local emesonargs=(
		-Dcoretext="disabled"
		-Dchafa="disabled"

		$(meson_feature glib)
		$(meson_feature graphite graphite2)
		$(meson_feature icu)
		$(meson_feature introspection gobject)
		$(meson_feature test tests)
		$(meson_feature truetype freetype)

		$(meson_native_use_feature cairo)
		$(meson_native_use_feature doc docs)
		$(meson_native_use_feature introspection)

		$(meson_use experimental experimental_api)
	)

	meson_src_configure
}
