# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
addr2line-0.17.0
adler-1.0.2
ahash-0.7.6
aho-corasick-0.7.18
android_log-sys-0.2.0
android_logger-0.10.1
ansi_term-0.11.0
ascii-0.9.3
atty-0.2.14
autocfg-1.1.0
backtrace-0.3.65
bitflags-1.3.2
block-buffer-0.9.0
byteorder-1.4.3
bytes-1.1.0
caseless-0.2.1
cbindgen-0.20.0
cc-1.0.73
cesu8-1.1.0
cfg-if-1.0.0
chrono-0.4.19
clap-2.33.4
combine-3.8.1
combine-4.6.4
crossbeam-channel-0.5.4
crossbeam-deque-0.8.1
crossbeam-epoch-0.9.8
crossbeam-utils-0.8.8
deunicode-0.4.3
digest-0.9.0
dirs-4.0.0
dirs-sys-0.3.7
dunce-1.0.2
either-1.6.1
env_logger-0.8.4
error-chain-0.12.4
fastrand-1.7.0
generic-array-0.14.5
getopts-0.2.21
getrandom-0.2.6
gimli-0.26.1
hashbrown-0.11.2
heck-0.3.3
hermit-abi-0.1.19
hex-0.4.3
indexmap-1.8.1
instant-0.1.12
itoa-1.0.1
jni-0.14.0
jni-0.18.0
jni-sys-0.3.0
json_comments-0.2.1
lazy_static-1.4.0
libc-0.2.124
linked-hash-map-0.5.4
log-0.4.16
lru-0.7.5
md-5-0.9.1
memchr-2.4.1
memoffset-0.6.5
miniz_oxide-0.5.1
ndk-0.6.0
ndk-sys-0.3.0
num-integer-0.1.44
num-traits-0.2.14
num_cpus-1.13.1
num_enum-0.5.7
num_enum_derive-0.5.7
object-0.28.3
once_cell-1.10.0
opaque-debug-0.3.0
proc-macro-crate-1.1.3
proc-macro2-1.0.37
quote-1.0.18
rayon-1.5.2
rayon-core-1.9.2
redox_syscall-0.2.13
redox_users-0.4.3
regex-1.5.5
regex-syntax-0.6.25
remove_dir_all-0.5.3
remove_dir_all-0.7.0
rustc-demangle-0.1.21
ryu-1.0.9
same-file-1.0.6
scopeguard-1.1.0
send_wrapper-0.5.0
serde-1.0.136
serde_derive-1.0.136
serde_json-1.0.79
serde_yaml-0.8.23
simplelog-0.10.2
slug-0.1.4
strsim-0.8.0
syn-1.0.91
tempfile-3.3.0
termcolor-1.1.3
textwrap-0.11.0
thiserror-1.0.30
thiserror-impl-1.0.30
time-0.1.43
tinyvec-1.6.0
tinyvec_macros-0.1.0
toml-0.5.9
typenum-1.15.0
unicode-normalization-0.1.19
unicode-segmentation-1.9.0
unicode-width-0.1.9
unicode-xid-0.2.2
unreachable-1.0.0
vec_map-0.8.2
version_check-0.9.4
void-1.0.2
walkdir-2.3.2
wasi-0.10.2+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
yaml-rust-0.4.5
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
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="public-domain SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cdinstall editor ru-gold test"
# ./ja2 -unittest can't find save files
RESTRICT="!test? ( test ) test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	>=dev-cpp/magic_enum-0.8.2
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
