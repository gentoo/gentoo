# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit flag-o-matic meson multilib-minimal python-any-r1 xdg-utils

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/HarfBuzz"

if [[ ${PV} = 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/harfbuzz/harfbuzz.git"
	inherit git-r3
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
fi

LICENSE="Old-MIT ISC icu"
SLOT="0/0.9.18" # 0.9.18 introduced the harfbuzz-icu split; bug #472416

IUSE="+cairo debug doc +glib +graphite icu +introspection static-libs test +truetype"
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

	sed -i \
		-e 's:tests/macos.tests::' \
		test/shaping/data/in-house/Makefile.sources \
		|| die # bug 726120

	# bug 618772
	append-cxxflags -std=c++14

	# bug 762415
	local pyscript
	for pyscript in $(find -type f -name "*.py") ; do
		python_fix_shebang -q "${pyscript}"
	done
}

meson_multilib_native_feature() {
	if multilib_is_native_abi && use "$1" ; then
		echo "enabled"
	else
		echo "disabled"
	fi
}

multilib_src_configure() {
	# harfbuzz-gobject only used for instrospection, bug #535852
	local emesonargs=(
		-Dcairo="$(meson_multilib_native_feature cairo)"
		-Dcoretext="disabled"
		-Ddocs="$(meson_multilib_native_feature doc)"
		-Dfontconfig="disabled" #609300
		-Dintrospection="$(meson_multilib_native_feature introspection)"
		-Dstatic="$(usex static-libs true false)"
		$(meson_feature glib)
		$(meson_feature graphite)
		$(meson_feature icu)
		$(meson_feature introspection gobject)
		$(meson_feature test tests)
		$(meson_feature truetype freetype)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	einstalldocs
}
