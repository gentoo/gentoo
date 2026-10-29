# Copyright 2004-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Build dir should be inside of source dir for tests
BUILD_DIR="${WORKDIR}/${P}/build"

RUST_MIN_VER="1.88.0"

# from pycargoebuild
CRATES="
	aho-corasick@1.1.4
	anstream@1.0.0
	anstyle-parse@1.0.0
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.14
	anyhow@1.0.103
	bitflags@2.13.0
	bumpalo@3.20.3
	cc@1.2.67
	cfg-if@1.0.4
	clap@4.6.1
	clap_builder@4.6.0
	clap_derive@4.6.1
	clap_lex@1.1.0
	clap_mangen@0.2.33
	colorchoice@1.0.5
	der@0.7.10
	env_filter@2.0.0
	env_logger@0.11.11
	errno@0.3.14
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fastrand@2.4.1
	find-msvc-tools@0.1.9
	foldhash@0.2.0
	getrandom@0.4.3
	hashbrown@0.16.1
	hashlink@0.11.1
	heck@0.5.0
	is_terminal_polyfill@1.70.2
	js-sys@0.3.103
	libc@0.2.186
	libsqlite3-sys@0.37.0
	linux-raw-sys@0.12.1
	log@0.4.33
	memchr@2.8.3
	once_cell@1.21.4
	once_cell_polyfill@1.70.2
	pkg-config@0.3.33
	proc-macro2@1.0.106
	quote@1.0.46
	r-efi@6.0.0
	regex-automata@0.4.15
	regex-syntax@0.8.11
	regex@1.13.0
	roff@1.1.1
	rsqlite-vfs@0.1.1
	rusqlite@0.39.0
	rustix@1.1.4
	rustversion@1.0.23
	shlex@2.0.1
	smallvec@1.15.2
	sqlite-wasm-rs@0.5.5
	strsim@0.11.1
	syn@2.0.118
	tempfile@3.27.0
	thiserror-impl@2.0.18
	thiserror@2.0.18
	unicode-ident@1.0.24
	utf8parse@0.2.2
	vcpkg@0.2.15
	wasm-bindgen-macro-support@0.2.126
	wasm-bindgen-macro@0.2.126
	wasm-bindgen-shared@0.2.126
	wasm-bindgen@0.2.126
	windows-link@0.2.1
	windows-sys@0.61.2
	zeroize@1.9.0
"

inherit cargo cmake unpacker

DESCRIPTION="The intelligent phonetic input method library"
HOMEPAGE="https://chewing.im/ https://codeberg.org/chewing/libchewing"
SRC_URI="https://codeberg.org/chewing/libchewing/releases/download/v${PV}/${P}.tar.zst
	${CARGO_CRATE_URIS}"

LICENSE="LGPL-2.1"
# Dependent crate licenses
LICENSE+=" MIT Unicode-3.0 ZLIB"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-build/cmake-3.27.0
	dev-build/corrosion
"
RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	test? ( sys-libs/ncurses[unicode(+)] )"

PATCHES=(
	"${FILESDIR}/libchewing-0.13.1_cmake_fixes.patch"
)

src_unpack() {
	unpacker ${P}.tar.zst
	cargo_src_unpack
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=$(usex test)
		-DCOMPRESS_MANS=OFF
		-DENABLE_GCOV=OFF
		-DWITH_SQLITE3=ON	# use system sqlite
		-DUSE_VALGRIND=OFF	# only for testing purpose
	)
	cmake_src_configure
}

src_compile() {
	cargo_env cmake_src_compile
}

src_test() {
	# https://github.com/chewing/libchewing/issues/293
	cmake_src_test -j1
}

src_install() {
	cargo_env cmake_src_install
}
