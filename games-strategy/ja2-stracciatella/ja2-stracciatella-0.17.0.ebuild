# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.10
ansi_term-0.11.0
arrayref-0.3.6
arrayvec-0.5.1
atty-0.2.14
autocfg-1.0.0
base64-0.11.0
bitflags-1.2.1
blake2b_simd-0.5.10
block-buffer-0.7.3
block-padding-0.1.5
byte-tools-0.3.1
byteorder-1.3.4
caseless-0.2.1
cbindgen-0.13.2
cfg-if-0.1.10
chrono-0.4.11
clap-2.33.0
constant_time_eq-0.1.5
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.2.1
crossbeam-utils-0.7.2
digest-0.8.1
dirs-1.0.5
dunce-1.0.0
either-1.5.3
generic-array-0.12.3
getopts-0.2.21
getrandom-0.1.14
hermit-abi-0.1.10
hex-0.3.2
indexmap-1.3.2
itoa-0.4.5
json_comments-0.2.0
lazy_static-1.4.0
libc-0.2.68
log-0.4.8
maybe-uninit-2.0.0
md-5-0.8.0
memchr-2.3.3
memoffset-0.5.4
num-integer-0.1.42
num-traits-0.2.11
num_cpus-1.12.0
opaque-debug-0.2.3
ppv-lite86-0.2.6
proc-macro2-1.0.10
quote-1.0.3
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
rayon-1.3.0
rayon-core-1.7.0
redox_syscall-0.1.56
redox_users-0.3.4
regex-1.3.6
regex-syntax-0.6.17
remove_dir_all-0.5.2
rust-argon2-0.7.0
ryu-1.0.3
scopeguard-1.1.0
serde-1.0.105
serde_derive-1.0.105
serde_json-1.0.50
simplelog-0.6.0
smallvec-1.2.0
strsim-0.8.0
syn-1.0.17
tempfile-3.1.0
term-0.5.2
textwrap-0.11.0
thread_local-1.0.1
time-0.1.42
toml-0.5.6
typenum-1.11.2
unicode-normalization-0.1.12
unicode-width-0.1.7
unicode-xid-0.2.0
vec_map-0.8.1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo cmake xdg

DESCRIPTION="An improved, cross-platform, stable Jagged Alliance 2 runtime"
HOMEPAGE="https://github.com/ja2-stracciatella/"
SRC_URI="https://github.com/ja2-stracciatella/ja2-stracciatella/archive/v${PV}.tar.gz -> ${P}.tar.gz
	editor? ( https://github.com/ja2-stracciatella/free-ja2-resources/releases/download/v1/editor.slf -> ${P}-editor.slf )
"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="public-domain SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="cdinstall editor ru-gold test"
# Run with ja2 --unittest
# Needs data files?
RESTRICT="test"
#RESTRICT="!test? ( test )"

DEPEND="
	media-libs/libsdl2[X,sound,video]
	!~media-libs/libsdl2-2.0.6
	>=virtual/rust-1.40.0
	>=x11-libs/fltk-1.3.5[opengl]
	>=dev-cpp/string-theory-3.1
	>=dev-games/libsmacker-1.1.1
	>=dev-libs/rapidjson-1.1.0
"
RDEPEND="
	${DEPEND}
	cdinstall? ( games-strategy/ja2-stracciatella-data )
"
DEPEND+="test? ( >=dev-cpp/gtest-1.9.0_pre20190607 )"

LANGS="l10n_de +l10n_en l10n_fr l10n_it l10n_nl l10n_pl l10n_ru"

IUSE="$IUSE $LANGS"
REQUIRED_USE="^^ ( ${LANGS//+/} )"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
		local mycmakeargs=()

		case ${L10N} in
			de) mycmakeargs+=" -DLNG=GERMAN" ;;
			nl) mycmakeargs+=" -DLNG=DUTCH" ;;
			fr) mycmakeargs+=" -DLNG=FRENCH" ;;
			it) mycmakeargs+=" -DLNG=ITALIAN" ;;
			pl) mycmakeargs+=" -DLNG=POLISH" ;;
			ru) mycmakeargs+=" -DLNG=$(usex ru-gold RUSSIAN_GOLD RUSSIAN)" ;;
			en) mycmakeargs+=" -DLNG=ENGLISH" ;;
			*) die "no language selected in L10N" ;;
		esac
		elog "Chosen language is ${mycmakeargs# -DLNG=}"

		mycmakeargs+=(
			-DLOCAL_GTEST_LIB=OFF
			-DLOCAL_RAPIDJSON_LIB=OFF
			-DLOCAL_STRING_THEORY_LIB=OFF
			-DWITH_UNITTESTS=$(usex test)
			-DWITH_RUST_BINARIES=OFF
			-DBUILD_LAUNCHER=OFF
			-DOPENGL_GL_PREFERENCE=GLVND
			-DINSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
			-DEXTRA_DATA_DIR="${EPREFIX}/usr/share/ja2"
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

pkg_postinst() {
	elog "You need ja2 in the chosen language, otherwise set it in package.use!"

	if ! use cdinstall ; then
		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "e.g. /opt/ja2/data and set game_dir in .ja2/ja2.json"
		elog "accordingly."
		elog "Make sure the filenames are lowercase."
	fi

	xdg_pkg_postinst
}
