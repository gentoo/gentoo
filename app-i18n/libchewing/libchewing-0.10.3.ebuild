# Copyright 2004-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Build dir should be inside of source dir for tests
BUILD_DIR="${WORKDIR}/${P}/build"

RUST_MIN_VER="1.88.0"

# from pycargoebuild
CRATES="
	anstream@0.6.20
	anstyle-parse@0.2.7
	anstyle-query@1.1.4
	anstyle-wincon@3.0.10
	anstyle@1.0.11
	anyhow@1.0.99
	bitflags@2.9.3
	cfg-if@1.0.3
	clap@4.5.45
	clap_builder@4.5.44
	clap_derive@4.5.45
	clap_lex@0.7.5
	clap_mangen@0.2.29
	colorchoice@1.0.4
	der@0.7.10
	env_filter@0.1.3
	env_logger@0.11.8
	errno@0.3.13
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fastrand@2.3.0
	foldhash@0.1.5
	getrandom@0.3.3
	hashbrown@0.15.5
	hashlink@0.10.0
	heck@0.5.0
	is_terminal_polyfill@1.70.1
	libc@0.2.175
	libsqlite3-sys@0.35.0
	linux-raw-sys@0.9.4
	log@0.4.27
	once_cell@1.21.3
	once_cell_polyfill@1.70.1
	pkg-config@0.3.32
	proc-macro2@1.0.101
	quote@1.0.40
	r-efi@5.3.0
	roff@0.2.2
	rusqlite@0.37.0
	rustix@1.0.8
	smallvec@1.15.1
	strsim@0.11.1
	syn@2.0.106
	tempfile@3.21.0
	unicode-ident@1.0.18
	utf8parse@0.2.2
	vcpkg@0.2.15
	wasi@0.14.2+wasi-0.2.4
	windows-link@0.1.3
	windows-sys@0.60.2
	windows-targets@0.53.3
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.53.0
	wit-bindgen-rt@0.39.0
	zeroize@1.8.1
"

inherit cargo cmake unpacker

DESCRIPTION="The intelligent phonetic input method library"
HOMEPAGE="https://chewing.im/ https://github.com/chewing/libchewing"
SRC_URI="https://github.com/chewing/libchewing/releases/download/v${PV}/${P}.tar.zst
	${CARGO_CRATE_URIS}"

LICENSE="LGPL-2.1"
# Dependent crate licenses
LICENSE+=" MIT Unicode-3.0 ZLIB"
SLOT="0/3"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-build/cmake-3.21.0
	dev-build/corrosion
"
RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}
	test? ( sys-libs/ncurses[unicode(+)] )"

PATCHES=(
	"${FILESDIR}/libchewing-0.10.3_man-compression.patch"
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
