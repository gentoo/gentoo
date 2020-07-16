# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
anyhow-1.0.26
aho-corasick-0.7.6
arrayvec-0.4.11
atty-0.2.14
autocfg-1.0.0
backtrace-0.3.37
backtrace-sys-0.1.31
bitflags-1.2.1
bstr-0.2.12
bumpalo-3.3.0
byteorder-1.3.4
cast-0.2.3
cc-1.0.53
cfg-if-0.1.10
clap-2.33.0
cmake-0.1.43
criterion-0.3.1
criterion-plot-0.4.1
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.2.1
crossbeam-utils-0.7.2
csv-1.1.3
csv-core-0.1.10
either-1.5.3
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
hermit-abi-0.1.8
idna-0.1.5
iovec-0.1.4
itertools-0.8.2
itoa-0.4.5
js-sys-0.3.39
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.70
libm-0.2.1
log-0.4.8
matches-0.1.8
maybe-uninit-2.0.0
memchr-2.3.3
memoffset-0.5.3
mio-0.6.22
miow-0.2.1
net2-0.2.34
num-traits-0.2.11
num_cpus-1.12.0
once_cell-1.4.0
oorandom-11.1.0
percent-encoding-1.0.1
plotters-0.2.12
proc-macro2-1.0.12
qlog-0.2.0
quote-1.0.5
rayon-1.3.0
rayon-core-1.7.0
regex-1.3.5
regex-automata-0.1.9
regex-syntax-0.6.17
ring-0.16.13
rustc_version-0.2.3
ryu-1.0.4
same-file-1.0.6
scopeguard-1.1.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.110
serde_derive-1.0.110
serde_json-1.0.53
serde_with-1.4.0
serde_with_macros-1.1.0
slab-0.4.2
smallvec-1.4.0
spin-0.5.2
syn-1.0.21
textwrap-0.11.0
tinytemplate-1.0.3
unicode-bidi-0.3.4
unicode-normalization-0.1.12
unicode-width-0.1.7
unicode-xid-0.1.0
unicode-xid-0.2.0
untrusted-0.7.1
url-1.7.2
walkdir-2.3.1
wasm-bindgen-0.2.62
wasm-bindgen-backend-0.2.62
wasm-bindgen-macro-0.2.62
wasm-bindgen-macro-support-0.2.62
wasm-bindgen-shared-0.2.62
wasm-bindgen-webidl-0.2.62
web-sys-0.3.39
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.3
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
"

inherit cargo cmake-utils flag-o-matic multilib-minimal rust-toolchain

DESCRIPTION="Implementation of the QUIC transport protocol and HTTP/3"
HOMEPAGE="https://github.com/cloudflare/quiche"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/cloudflare/${PN}.git"
	inherit git-r3
else
	CRATES+=" ${P//_/-}"
	SRC_URI="$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/${P//_/-}"
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
DOCS=( CODEOWNERS  COPYING README.md )

BDEPEND="
	>=virtual/rust-1.39.0[${MULTILIB_USEDEP}]
	dev-util/cmake
	dev-lang/go
	dev-lang/perl
"
DEPEND=""
RDEPEND=""

CMAKE_USE_DIR="${S}/deps/boringssl"

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
	default
	cmake-utils_src_prepare
	multilib_copy_sources
}

multilib_src_configure() {
	append-flags "-fPIC"
	local mycmakeargs=(
		-DOPENSSL_NO_ASM=ON
		-DBUILD_SHARED_LIBS=OFF
	)
	BUILD_DIR="${BUILD_DIR}/deps/boringssl/build" cmake-utils_src_configure
}

multilib_src_compile() {
	BUILD_DIR="${BUILD_DIR}/deps/boringssl/build" cmake-utils_src_compile bssl
	QUICHE_BSSL_PATH="${BUILD_DIR}/deps/boringssl" cargo_src_compile --features pkg-config-meta --target="$(rust_abi)"
}

multilib_src_test() {
	QUICHE_BSSL_PATH="${BUILD_DIR}/deps/boringssl" cargo_src_test  --target="$(rust_abi)"
}

multilib_src_install() {
	sed -i -e "s:libdir=.\+:libdir=${EPREFIX}/usr/$(get_libdir):" -e "s:includedir=.\+:includedir=${EPREFIX}/usr/include:" target/release/quiche.pc || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins target/release/quiche.pc
	doheader -r include/*
	dolib.so "target/$(rust_abi)/release/libquiche.so"
}
