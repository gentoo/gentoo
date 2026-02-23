# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.17.0
	adler@1.0.2
	ahash@0.7.6
	aho-corasick@0.7.18
	ansi_term@0.11.0
	anyhow@1.0.69
	ascii@0.9.3
	atty@0.2.14
	autocfg@1.1.0
	backtrace@0.3.65
	base64@0.13.1
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.3
	bytecount@0.6.3
	byteorder@1.4.3
	bytes@1.4.0
	caseless@0.2.1
	cbindgen@0.20.0
	cc@1.0.73
	cesu8@1.1.0
	cfg-if@1.0.0
	clap@2.33.4
	combine@3.8.1
	combine@4.6.4
	crossbeam-channel@0.5.4
	crossbeam-deque@0.8.1
	crossbeam-epoch@0.9.8
	crossbeam-utils@0.8.8
	crypto-common@0.1.6
	cty@0.2.2
	deunicode@0.4.3
	digest@0.10.6
	dirs-sys@0.3.7
	dirs@4.0.0
	dunce@1.0.2
	either@1.6.1
	equivalent@1.0.1
	errno@0.3.8
	error-chain@0.12.4
	fancy-regex@0.8.0
	fastrand@2.0.2
	fluent-uri@0.1.4
	form_urlencoded@1.1.0
	fraction@0.10.0
	generic-array@0.14.5
	getopts@0.2.21
	getrandom@0.2.12
	gimli@0.26.1
	hashbrown@0.12.3
	hashbrown@0.14.5
	heck@0.3.3
	hermit-abi@0.1.19
	hex@0.4.3
	idna@0.3.0
	indexmap@1.9.2
	indexmap@2.3.0
	iso8601@0.4.2
	itoa@1.0.1
	jni-sys@0.3.0
	jni@0.14.0
	jni@0.19.0
	json-patch@2.0.0
	json_comments@0.2.1
	jsonptr@0.4.7
	jsonschema@0.16.0
	lazy_static@1.4.0
	libc@0.2.153
	linux-raw-sys@0.4.13
	lock_api@0.4.9
	log@0.4.16
	lru@0.8.1
	md-5@0.10.5
	memchr@2.4.1
	memoffset@0.6.5
	minimal-lexical@0.2.1
	miniz_oxide@0.5.1
	ndk-sys@0.4.1+23.1.7779620
	ndk@0.7.0
	nom@7.1.3
	num-bigint@0.2.6
	num-cmp@0.1.0
	num-complex@0.2.4
	num-integer@0.1.45
	num-iter@0.1.43
	num-rational@0.2.4
	num-traits@0.2.15
	num@0.2.1
	num_cpus@1.13.1
	num_enum@0.5.7
	num_enum_derive@0.5.7
	num_threads@0.1.6
	object@0.28.3
	once_cell@1.10.0
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	percent-encoding@2.2.0
	proc-macro-crate@1.1.3
	proc-macro2@1.0.86
	quote@1.0.36
	raw-window-handle@0.5.0
	rayon-core@1.10.2
	rayon@1.6.1
	redox_syscall@0.2.13
	redox_users@0.4.3
	regex-syntax@0.6.28
	regex@1.7.1
	rustc-demangle@0.1.21
	rustix@0.38.32
	ryu@1.0.9
	same-file@1.0.6
	scopeguard@1.1.0
	send_wrapper@0.6.0
	serde@1.0.204
	serde_derive@1.0.204
	serde_json@1.0.122
	serde_yaml@0.9.17
	simplelog@0.12.0
	slug@0.1.4
	smallvec@1.10.0
	strsim@0.8.0
	syn@1.0.107
	syn@2.0.72
	tempfile@3.10.1
	termcolor@1.1.3
	textwrap@0.11.0
	thiserror-impl@1.0.63
	thiserror@1.0.63
	time-macros@0.2.4
	time@0.3.15
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.5.9
	typenum@1.15.0
	unicode-bidi@0.3.10
	unicode-ident@1.0.6
	unicode-normalization@0.1.19
	unicode-segmentation@1.10.1
	unicode-width@0.1.9
	unreachable@1.0.0
	unsafe-libyaml@0.2.10
	url@2.3.1
	uuid@0.8.2
	vec_map@0.8.2
	version_check@0.9.4
	void@1.0.2
	walkdir@2.3.2
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.52.0
	windows-targets@0.42.1
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.42.1
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.42.1
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.42.1
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.42.1
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.42.1
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.42.1
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.42.1
	windows_x86_64_msvc@0.52.4
"

# There's something screwy that means this doesn't build with nightly
# but 1.94.0 beta seems fine; I'm assuming this is a bad version check
# in a dependent crate.
RUST_MIN_VER=1.85.1

# See dependencies/lib-lua/CMakeLists.txt
LUA_COMPAT=( lua5-3 )

inherit cargo cmake lua-single xdg

DESCRIPTION="An improved, cross-platform, stable Jagged Alliance 2 runtime"
HOMEPAGE="https://ja2-stracciatella.github.io/"
SRC_URI="
	https://github.com/ja2-stracciatella/ja2-stracciatella/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	editor? (
		https://github.com/ja2-stracciatella/free-ja2-resources/releases/download/v1/editor.slf -> ${PN}-editor.slf
		)
	${CARGO_CRATE_URIS}
"

LICENSE="public-domain SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="cdinstall editor +launcher ru-gold test"
# ./ja2 -unittest can't find save files
RESTRICT="!test? ( test ) test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	>=dev-cpp/magic_enum-0.9.7
	>=dev-cpp/sol2-3.3.0
	>=dev-cpp/string-theory-3.1
	>=dev-games/libsmacker-1.2.0_p43-r1
	>=dev-libs/miniaudio-0.11.11
	media-libs/libsdl2[X,sound,video]
	launcher? ( x11-libs/fltk:1= )
"
RDEPEND="
	${DEPEND}
	cdinstall? ( games-strategy/ja2-stracciatella-data )
"

pkg_setup() {
	lua-single_pkg_setup
	rust_pkg_setup
}

src_prepare() {
	PATCHES=(
		"${FILESDIR}"/${P}-system-smacker.patch
		"${FILESDIR}"/${P}-magic_enum.patch
		"${FILESDIR}"/${PN}-0.20.0-lua-cmake.patch
	)
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLUA_VERSION="${ELUA#lua}"
		-DUSE_SCCACHE=OFF

		# Local means vendored, not system.
		-DLOCAL_FLTK_LIB=OFF
		-DLOCAL_GTEST_LIB=OFF
		-DLOCAL_LUA_LIB=OFF
		-DLOCAL_MAGICENUM_LIB=OFF
		-DLOCAL_MINIAUDIO_LIB=OFF
		-DLOCAL_SDL_LIB=OFF
		-DLOCAL_SMACKER_LIB=OFF
		-DLOCAL_SOL_LIB=OFF
		-DLOCAL_STRING_THEORY_LIB=OFF

		-DWITH_MAGICENUM=ON
		-DWITH_RUST_BINARIES=OFF
		-DWITH_UNITTESTS=$(usex test)

		-DBUILD_LAUNCHER=$(usex launcher)

		-DINSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DEXTRA_DATA_DIR="${EPREFIX}/usr/share/ja2"
		-DMINIAUDIO_INCLUDE_DIR="${EPREFIX}/usr/include/miniaudio"
	)

	cargo_gen_config
	cmake_src_configure
}

src_install() {
	if use editor; then
		insinto /usr/share/ja2
		doins "${DISTDIR}/${PN}-editor.slf"
		dosym "${PN}-editor.slf" "/usr/share/ja2/editor.slf"
	fi

	cmake_src_install
}

src_test() {
	"${BUILD_DIR}"/ja2 -unittests || die
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] && use !cdinstall; then
		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "e.g. /opt/ja2/data and set game_dir in .ja2/ja2.json"
		elog "accordingly."
		elog "Make sure the filenames are lowercase."
	fi

	xdg_pkg_postinst
}
