# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{11..14} )
RUST_MIN_VER=1.89.0
inherit cargo lua-single meson python-any-r1 xdg

DESCRIPTION="2D space trading and combat game, in a similar vein to Escape Velocity"
HOMEPAGE="https://naev.org/"
# creating the vendor tarball first requires running src_compile until
# it fails downloading crates in sandbox to generate several cargo files
SRC_URI="
	https://codeberg.org/naev/naev/releases/download/v${PV}/${P}-source.tar.xz
	https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz
"

LICENSE="GPL-3+ BSD BSD-2 MIT"
LICENSE+="
	Apache-2.0 CC-BY-2.0 CC-BY-3.0 CC-BY-4.0 CC-BY-SA-2.0 CC-BY-SA-3.0
	CC-BY-SA-4.0 CC0-1.0 FDL-1.2 GPL-2+ OFL-1.1 public-domain
" # assets
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0
	CDLA-Permissive-2.0 IJG ISC MIT MIT-0 MPL-2.0 openssl Unicode-3.0
	ZLIB
" # crates
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"

# tests been a headache to keep working in sandbox with software GL
RESTRICT="test"

# dlopen: libglvnd
RDEPEND="
	${LUA_DEPS}
	app-text/cmark:=
	dev-games/physfs
	>=dev-libs/libgit2-1.9.2:0/1.9
	dev-libs/libpcre2:=
	dev-libs/libunibreak:=
	dev-libs/libxml2:=
	dev-libs/openssl:=
	media-libs/dav1d:=
	media-libs/freetype:2
	media-libs/libglvnd
	media-libs/libsdl3[opengl]
	media-libs/libvorbis
	media-libs/openal
	media-libs/opus
	net-libs/enet:1.3=
	net-libs/libssh2
	sci-libs/cholmod
	sci-libs/cxsparse
	sci-libs/openblas
	sci-libs/suitesparse
	sci-mathematics/glpk:=
	virtual/libintl
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	>=dev-build/meson-1.7.0
	>=dev-util/bindgen-0.72.0
	sys-devel/gettext
	doc? (
		app-text/doxygen
		dev-lua/ldoc
		media-gfx/graphviz
	)
"

QA_FLAGS_IGNORED="usr/lib.*/libnaev_rlib.so" # rust

python_check_deps() {
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
}

pkg_setup() {
	lua-single_pkg_setup
	python-any-r1_pkg_setup
	rust_pkg_setup
}

src_prepare() {
	default

	# don't probe OpenGL for tests (avoids sandbox violations, bug #829369)
	sed -i "/subdir('glcheck')/d" test/meson.build || die

	# meson.build overrides CARGO_HOME, symlink to use our config.toml
	# (note need to set BUILD_DIR either way due to cargo_env's subshell)
	BUILD_DIR=${WORKDIR}/${P}-build
	mkdir -p -- "${BUILD_DIR}" || die
	ln -s -- "${CARGO_HOME}" "${BUILD_DIR}"/cargo-home || die
}

src_configure() {
	export LIBGIT2_NO_VENDOR=1
	export LIBSSH2_SYS_USE_PKG_CONFIG=1

	local emesonargs=(
		# *can* do lua5-1 but upstream uses+test luajit most (bug #946881)
		-Dluajit=enabled
		$(meson_feature doc docs_c)
		$(meson_feature doc docs_lua)
	)

	cargo_env meson_src_configure
}

src_compile() {
	cargo_env meson_src_compile
}

src_install() {
	local DOCS=( Changelog.md Readme.md )
	cargo_env meson_src_install

	if use doc; then
		dodir /usr/share/doc/${PF}/html
		mv -- "${ED}"/usr/{doc/naev/{c,lua},share/doc/${PF}/html} || die
		rm -r -- "${ED}"/usr/doc || die
	fi

	rm -r -- "${ED}"/usr/share/doc/naev || die
}
