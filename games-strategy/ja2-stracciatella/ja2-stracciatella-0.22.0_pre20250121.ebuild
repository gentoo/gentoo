# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	ahash@0.7.8
	ahash@0.8.11
	aho-corasick@1.1.3
	ansi_term@0.11.0
	anyhow@1.0.98
	ascii@0.9.3
	atty@0.2.14
	autocfg@1.4.0
	backtrace@0.3.74
	base64@0.13.1
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.9.0
	block-buffer@0.10.4
	bumpalo@3.17.0
	bytecount@0.6.8
	byteorder@1.5.0
	bytes@1.10.1
	caseless@0.2.2
	cbindgen@0.20.0
	cesu8@1.1.0
	cfg-if@1.0.0
	clap@2.33.4
	combine@3.8.1
	combine@4.6.7
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	deranged@0.4.0
	deunicode@1.6.1
	digest@0.10.7
	dirs-sys@0.3.7
	dirs@4.0.0
	displaydoc@0.2.5
	dunce@1.0.5
	either@1.15.0
	equivalent@1.0.2
	errno@0.3.11
	error-chain@0.12.4
	fancy-regex@0.10.0
	fastrand@2.3.0
	fluent-uri@0.1.4
	form_urlencoded@1.2.1
	fraction@0.12.2
	generic-array@0.14.7
	getopts@0.2.21
	getrandom@0.2.15
	getrandom@0.3.2
	gimli@0.31.1
	hashbrown@0.12.3
	hashbrown@0.15.2
	heck@0.3.3
	hermit-abi@0.1.19
	hex@0.4.3
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.1
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.1
	icu_properties@1.5.1
	icu_properties_data@1.5.1
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	indexmap@1.9.3
	indexmap@2.9.0
	iso8601@0.5.1
	itoa@1.0.15
	jni-sys@0.3.0
	jni@0.14.0
	jni@0.19.0
	json-patch@2.0.0
	json_comments@0.2.2
	jsonptr@0.4.7
	jsonschema@0.16.1
	lazy_static@1.5.0
	libc@0.2.172
	libredox@0.1.3
	linux-raw-sys@0.9.4
	litemap@0.7.5
	lock_api@0.4.12
	log@0.4.27
	lru@0.8.1
	md-5@0.10.6
	memchr@2.7.4
	minimal-lexical@0.2.1
	miniz_oxide@0.8.8
	ndk-sys@0.4.1+23.1.7779620
	ndk@0.7.0
	nom@7.1.3
	num-bigint@0.4.6
	num-cmp@0.1.0
	num-complex@0.4.6
	num-conv@0.1.0
	num-integer@0.1.46
	num-iter@0.1.45
	num-rational@0.4.2
	num-traits@0.2.19
	num@0.4.3
	num_enum@0.5.11
	num_enum_derive@0.5.11
	num_threads@0.1.7
	object@0.36.7
	once_cell@1.21.3
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	percent-encoding@2.3.1
	powerfmt@0.2.0
	proc-macro-crate@1.3.1
	proc-macro2@1.0.95
	quote@1.0.40
	r-efi@5.2.0
	raw-window-handle@0.5.2
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.11
	redox_users@0.4.6
	regex-automata@0.4.9
	regex-syntax@0.8.5
	regex@1.11.1
	rustc-demangle@0.1.24
	rustix@1.0.5
	rustversion@1.0.20
	ryu@1.0.20
	same-file@1.0.6
	scopeguard@1.2.0
	send_wrapper@0.6.0
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.140
	serde_yaml@0.9.34+deprecated
	simplelog@0.12.2
	slug@0.1.6
	smallvec@1.15.0
	stable_deref_trait@1.2.0
	strsim@0.8.0
	syn@1.0.109
	syn@2.0.100
	synstructure@0.13.1
	tempfile@3.19.1
	termcolor@1.4.1
	textwrap@0.11.0
	thiserror-impl@1.0.69
	thiserror@1.0.69
	time-core@0.1.4
	time-macros@0.2.22
	time@0.3.41
	tinystr@0.7.6
	tinyvec@1.9.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	toml_datetime@0.6.8
	toml_edit@0.19.15
	typenum@1.18.0
	unicode-ident@1.0.18
	unicode-normalization@0.1.24
	unicode-segmentation@1.12.0
	unicode-width@0.1.14
	unreachable@1.0.0
	unsafe-libyaml@0.2.11
	url@2.5.4
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	uuid@1.16.0
	vec_map@0.8.2
	version_check@0.9.5
	void@1.0.2
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.14.2+wasi-0.2.4
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.5.40
	wit-bindgen-rt@0.39.0
	write16@1.0.0
	writeable@0.5.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerovec-derive@0.10.3
	zerovec@0.10.4
"

# See dependencies/lib-lua/CMakeLists.txt
LUA_COMPAT=( lua5-3 )

inherit cargo cmake lua-single xdg

DESCRIPTION="An improved, cross-platform, stable Jagged Alliance 2 runtime"
HOMEPAGE="https://ja2-stracciatella.github.io/"
MY_COMMIT=1ca63145ffe295e9110464e95579bfb376b67a26
SRC_URI="
	https://codeload.github.com/ja2-stracciatella/ja2-stracciatella/tar.gz/${MY_COMMIT} -> ${P}.tar.gz
	https://github.com/Kangie/ja2-stracciatella/commit/c038d98ff0cee6847abb3dc951de95cd0617773e.patch -> ${P}-rust.patch
	editor? ( https://github.com/ja2-stracciatella/free-ja2-resources/releases/download/v1/editor.slf -> ${P}-editor.slf )
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="public-domain SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="cdinstall editor ru-gold test"
# ./ja2 -unittest can't find save files
RESTRICT="!test? ( test ) test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	>=dev-cpp/magic_enum-0.9.5
	>=dev-cpp/sol2-3.3.0
	>=dev-cpp/string-theory-3.1
	>=dev-games/libsmacker-1.1.1
	>=dev-libs/miniaudio-0.11.11
	>=dev-libs/rapidjson-1.1.0
	media-libs/libsdl2[X,sound,video]
"
RDEPEND="
	${DEPEND}
	cdinstall? ( games-strategy/ja2-stracciatella-data )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20.0-lua-cmake.patch
	"${DISTDIR}"/${P}-rust.patch
)

pkg_setup() {
	lua-single_pkg_setup
	rust_pkg_setup
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DUSE_SCCACHE=OFF

		-DLOCAL_GTEST_LIB=OFF
		-DLOCAL_FLTK_LIB=OFF

		-DLOCAL_LUA_LIB=OFF
		-DLUA_VERSION="${ELUA#lua}"

		-DLOCAL_MAGICENUM_LIB=OFF
		-DLOCAL_MINIAUDIO_LIB=OFF
		-DLOCAL_RAPIDJSON_LIB=OFF
		-DLOCAL_SDL_LIB=OFF
		-DLOCAL_SOL_LIB=OFF
		-DLOCAL_STRING_THEORY_LIB=OFF

		-DWITH_MAGICENUM=OFF
		-DWITH_RUST_BINARIES=OFF
		-DWITH_UNITTESTS=$(usex test)

		-DBUILD_LAUNCHER=OFF

		-DINSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		-DEXTRA_DATA_DIR="${EPREFIX}/usr/share/ja2"
		-DMINIAUDIO_INCLUDE_DIR="${EPREFIX}/usr/include/miniaudio"
		-DMAGICENUM_INCLUDE_DIR="${EPREFIX}/usr/include"
	)

	cargo_gen_config
	cmake_src_configure
}

src_install() {
	if use editor; then
		insinto /usr/share/ja2
		doins "${DISTDIR}/${P}-editor.slf"
		dosym "${P}-editor.slf" "/usr/share/ja2/editor.slf"
	fi

	cmake_src_install
}

src_test() {
	"${BUILD_DIR}"/ja2 -unittests || die
}

pkg_postinst() {
	if ! use cdinstall ; then
		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "e.g. /opt/ja2/data and set game_dir in .ja2/ja2.json"
		elog "accordingly."
		elog "Make sure the filenames are lowercase."
	fi

	xdg_pkg_postinst
}
