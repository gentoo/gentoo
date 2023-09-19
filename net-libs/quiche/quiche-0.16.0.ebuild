# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
anyhow-1.0.26
ansi_term-0.11.0
aho-corasick-0.7.18
arrayvec-0.7.2
atty-0.2.14
autocfg-1.1.0
backtrace-0.3.37
backtrace-sys-0.1.31
bindgen-0.60.1
bitflags-1.3.2
boring-2.1.0
boring-sys-2.1.0
bstr-0.2.12
bumpalo-3.11.0
byteorder-1.3.4
cast-0.2.3
cc-1.0.73
cexpr-0.6.0
cfg-if-0.1.10
cfg-if-1.0.0
clang-sys-1.4.0
clap-2.33.3
cmake-0.1.48
criterion-0.3.1
criterion-plot-0.4.1
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.2.1
crossbeam-utils-0.7.2
csv-1.1.3
csv-core-0.1.10
either-1.5.3
darling-0.13.4
darling_core-0.13.4
darling_macro-0.13.4
data-encoding-2.3.2
env_logger-0.8.4
fnv-1.0.7
foreign-types-0.5.0
foreign-types-macros-0.2.2
foreign-types-shared-0.3.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
glob-0.3.0
hashbrown-0.12.3
hermit-abi-0.1.19
humantime-2.1.0
ident_case-1.0.1
idna-0.1.5
iovec-0.1.4
itertools-0.8.2
itoa-1.0.4
js-sys-0.3.60
kernel32-sys-0.2.2
lazycell-1.3.0
lazy_static-1.4.0
libc-0.2.135
libloading-0.7.3
libm-0.2.5
log-0.4.17
matches-0.1.9
maybe-uninit-2.0.0
memchr-2.5.0
memoffset-0.5.3
minimal-lexical-0.2.1
mio-0.8.4
miow-0.4.0
net2-0.2.37
nom-7.1.1
num-traits-0.2.15
num_cpus-1.12.0
octets-0.2.0
peeking_take_while-0.1.2
indexmap-1.9.1
once_cell-1.15.0
oorandom-11.1.0
percent-encoding-1.0.1
plotters-0.2.12
proc-macro2-1.0.46
qlog-0.8.0
quote-1.0.21
rayon-1.3.0
rayon-core-1.7.0
regex-1.6.0
regex-automata-0.2.0
regex-syntax-0.6.27
ring-0.16.20
rustc_version-0.2.3
rustc-hash-1.1.0
rustversion-1.0.6
rust_decimal-1.26.1
ryu-1.0.11
same-file-1.0.6
scopeguard-1.1.0
sfv-0.9.2
semver-0.9.0
semver-parser-0.7.0
serde-1.0.145
serde_derive-1.0.145
serde_json-1.0.86
serde_with-1.14.0
serde_with_macros-1.5.2
shlex-1.1.0
slab-0.4.7
smallvec-1.4.0
spin-0.5.2
strsim-0.8.0
strsim-0.10.0
syn-1.0.102
termcolor-1.1.2
textwrap-0.11.0
tinytemplate-1.0.3
tinyvec-1.6.0
tinyvec_macros-0.1.0
unicode-bidi-0.3.8
unicode-ident-1.0.5
unicode-normalization-0.1.22
unicode-width-0.1.10
unicode-xid-0.2.4
unicode-xid-0.2.3
untrusted-0.7.1
url-1.7.2
vec_map-0.8.2
version_check-0.9.4
walkdir-2.3.1
wasm-bindgen-0.2.83
wasm-bindgen-backend-0.2.83
wasm-bindgen-macro-0.2.83
wasm-bindgen-macro-support-0.2.83
wasm-bindgen-shared-0.2.83
wasm-bindgen-webidl-0.2.75
wasi-0.11.0+wasi-snapshot-preview1
web-sys-0.3.60
which-3.1.1
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows_aarch64_msvc-0.36.1
windows_i686_gnu-0.36.1
windows_i686_msvc-0.36.1
windows_x86_64_gnu-0.36.1
windows_x86_64_msvc-0.36.1
windows-sys-0.36.1
ws2_32-sys-0.2.1
"

inherit cargo cmake flag-o-matic rust-toolchain multilib-minimal

DESCRIPTION="Implementation of the QUIC transport protocol and HTTP/3"
HOMEPAGE="https://github.com/cloudflare/quiche"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/cloudflare/${PN}.git"
	inherit git-r3
	CMAKE_USE_DIR="${S}/quiche/deps/boringssl"
else
	CRATES+=" ${P//_/-}"
	SRC_URI="$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${P//_/-}"
	CMAKE_USE_DIR="${S}/deps/boringssl"
fi

LICENSE="|| ( Apache-2.0 Boost-1.0 )
	|| ( Apache-2.0 MIT )
	|| ( Apache-2.0-with-LLVM-exceptions Apache-2.0 MIT )
	BSD-2
	BSD
	ISC
	MIT
	|| ( Unlicense MIT )
	openssl"
SLOT="0/0"
IUSE=""
DOCS=( COPYING README.md )

BDEPEND="
	>=virtual/rust-1.56.0[${MULTILIB_USEDEP}]
	dev-util/cmake
"
DEPEND=""
RDEPEND=""

BUILD_DIR="${WORKDIR}/${P}"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
		tar -xf "${DISTDIR}/${P//_/-}.crate" -C "${WORKDIR}" || die
	fi
}

src_prepare() {
	cmake_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	append-flags "-fPIC"
	local mycmakeargs=(
		-DOPENSSL_NO_ASM=ON
		-DBUILD_SHARED_LIBS=OFF
	)
	BUILD_DIR="${BUILD_DIR}/deps/boringssl/build" cmake_src_configure
}

multilib_src_compile() {
	BUILD_DIR="${BUILD_DIR}/deps/boringssl/build" cmake_src_compile bssl
	QUICHE_BSSL_PATH="${BUILD_DIR}/deps/boringssl" cargo_src_compile --features "ffi pkg-config-meta" --target="$(rust_abi)"
}

multilib_src_test() {
	QUICHE_BSSL_PATH="${BUILD_DIR}/deps/boringssl" cargo_src_test  --target="$(rust_abi)"
}

multilib_src_install() {
	sed -i -e "s:libdir=.\+:libdir=${EPREFIX}/usr/$(get_libdir):" -e "s:includedir=.\+:includedir=${EPREFIX}/usr/include:" target/$(rust_abi)/release/quiche.pc || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins target/$(rust_abi)/release/quiche.pc
	doheader -r include/*
	dolib.so "target/$(rust_abi)/release/libquiche.so"
	QA_FLAGS_IGNORED+=" usr/$(get_libdir)/libquiche.so" # rust libraries don't use LDFLAGS
	QA_SONAME+=" usr/$(get_libdir)/libquiche.so" # https://github.com/cloudflare/quiche/issues/165
}
