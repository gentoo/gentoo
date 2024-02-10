# Copyright 1999-2023 Gentoo Authors
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
dirs@4.0.0
dirs-sys@0.3.7
dunce@1.0.2
either@1.6.1
error-chain@0.12.4
fancy-regex@0.8.0
fastrand@1.7.0
form_urlencoded@1.1.0
fraction@0.10.0
generic-array@0.14.5
getopts@0.2.21
getrandom@0.2.6
gimli@0.26.1
hashbrown@0.12.3
heck@0.3.3
hermit-abi@0.1.19
hex@0.4.3
idna@0.3.0
indexmap@1.9.2
instant@0.1.12
iso8601@0.4.2
itoa@1.0.1
jni@0.14.0
jni@0.19.0
jni-sys@0.3.0
json_comments@0.2.1
jsonschema@0.16.0
lazy_static@1.4.0
libc@0.2.124
lock_api@0.4.9
log@0.4.16
lru@0.8.1
md-5@0.10.5
memchr@2.4.1
memoffset@0.6.5
minimal-lexical@0.2.1
miniz_oxide@0.5.1
ndk@0.7.0
ndk-sys@0.4.1+23.1.7779620
nom@7.1.3
num@0.2.1
num-bigint@0.2.6
num-cmp@0.1.0
num-complex@0.2.4
num-integer@0.1.45
num-iter@0.1.43
num-rational@0.2.4
num-traits@0.2.15
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
proc-macro2@1.0.51
quote@1.0.18
raw-window-handle@0.5.0
rayon@1.6.1
rayon-core@1.10.2
redox_syscall@0.2.13
redox_users@0.4.3
regex@1.7.1
regex-syntax@0.6.28
remove_dir_all@0.5.3
rustc-demangle@0.1.21
ryu@1.0.9
same-file@1.0.6
scopeguard@1.1.0
send_wrapper@0.6.0
serde@1.0.152
serde_derive@1.0.152
serde_json@1.0.93
serde_yaml@0.9.17
simplelog@0.12.0
slug@0.1.4
smallvec@1.10.0
strsim@0.8.0
syn@1.0.107
tempfile@3.3.0
termcolor@1.1.3
textwrap@0.11.0
thiserror@1.0.30
thiserror-impl@1.0.30
time@0.3.15
time-macros@0.2.4
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
unsafe-libyaml@0.2.5
url@2.3.1
uuid@0.8.2
vec_map@0.8.2
version_check@0.9.4
void@1.0.2
walkdir@2.3.2
wasi@0.10.2+wasi-snapshot-preview1
winapi@0.3.9
winapi-i686-pc-windows-gnu@0.4.0
winapi-util@0.1.5
winapi-x86_64-pc-windows-gnu@0.4.0
windows-sys@0.45.0
windows-targets@0.42.1
windows_aarch64_gnullvm@0.42.1
windows_aarch64_msvc@0.42.1
windows_i686_gnu@0.42.1
windows_i686_msvc@0.42.1
windows_x86_64_gnu@0.42.1
windows_x86_64_gnullvm@0.42.1
windows_x86_64_msvc@0.42.1
"

# See dependencies/lib-lua/CMakeLists.txt
LUA_COMPAT=( lua5-3 )

inherit cargo cmake lua-single xdg

DESCRIPTION="An improved, cross-platform, stable Jagged Alliance 2 runtime"
HOMEPAGE="https://github.com/ja2-stracciatella/"
SRC_URI="
	https://github.com/ja2-stracciatella/ja2-stracciatella/archive/v${PV}.tar.gz -> ${P}.tar.gz
	editor? ( https://github.com/ja2-stracciatella/free-ja2-resources/releases/download/v1/editor.slf -> ${P}-editor.slf )
"
SRC_URI+=" $(cargo_crate_uris ${CARGO_CRATES_URIS})"

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
	>=x11-libs/fltk-1.3.5[opengl]
	>=virtual/rust-1.40.0
"
RDEPEND="
	${DEPEND}
	cdinstall? ( games-strategy/ja2-stracciatella-data )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.20.0-lua-cmake.patch
)

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
