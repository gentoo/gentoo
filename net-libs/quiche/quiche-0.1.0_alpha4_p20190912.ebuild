# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.6
arrayvec-0.4.11
atty-0.2.13
autocfg-0.1.6
backtrace-0.3.37
backtrace-sys-0.1.31
bitflags-1.1.0
bstr-0.2.8
bumpalo-2.6.0
byteorder-1.3.2
cast-0.2.2
cc-1.0.45
cfg-if-0.1.9
clap-2.33.0
cmake-0.1.42
criterion-0.3.0
criterion-plot-0.4.0
crossbeam-deque-0.7.1
crossbeam-epoch-0.7.2
crossbeam-queue-0.1.2
crossbeam-utils-0.6.6
csv-1.1.1
csv-core-0.1.6
docopt-1.1.0
either-1.5.2
env_logger-0.6.2
failure-0.1.5
failure_derive-0.1.5
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
getrandom-0.1.12
heck-0.3.1
humantime-1.3.0
idna-0.1.5
iovec-0.1.2
itertools-0.8.0
itoa-0.4.4
js-sys-0.3.27
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.62
log-0.4.8
matches-0.1.8
memchr-2.2.1
memoffset-0.5.1
mio-0.6.19
miow-0.2.1
net2-0.2.33
nodrop-0.1.13
nom-4.2.3
num-traits-0.2.8
num_cpus-1.10.1
percent-encoding-1.0.1
proc-macro2-0.4.30
proc-macro2-1.0.3
quick-error-1.2.2
quote-0.6.13
quote-1.0.2
rand_core-0.5.1
rand_os-0.2.2
rand_xoshiro-0.3.1
rayon-1.2.0
rayon-core-1.6.0
regex-1.3.1
regex-automata-0.1.8
regex-syntax-0.6.12
ring-0.16.9
rustc-demangle-0.1.16
rustc_version-0.2.3
ryu-1.0.0
same-file-1.0.5
scopeguard-1.0.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.100
serde_derive-1.0.100
serde_json-1.0.40
slab-0.4.2
smallvec-0.6.10
sourcefile-0.1.4
spin-0.5.2
strsim-0.9.2
syn-0.15.44
syn-1.0.5
synstructure-0.10.2
termcolor-1.0.5
textwrap-0.11.0
thread_local-0.3.6
tinytemplate-1.0.2
unicode-bidi-0.3.4
unicode-normalization-0.1.8
unicode-segmentation-1.3.0
unicode-width-0.1.6
unicode-xid-0.1.0
unicode-xid-0.2.0
untrusted-0.7.0
url-1.7.2
version_check-0.1.5
walkdir-2.2.9
wasi-0.7.0
wasm-bindgen-0.2.50
wasm-bindgen-backend-0.2.50
wasm-bindgen-macro-0.2.50
wasm-bindgen-macro-support-0.2.50
wasm-bindgen-shared-0.2.50
wasm-bindgen-webidl-0.2.50
web-sys-0.3.27
weedle-0.10.0
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.2
ws2_32-sys-0.2.1
"

inherit cargo multilib-minimal

DESCRIPTION="Implementation of the QUIC transport protocol and HTTP/3"
HOMEPAGE="https://github.com/cloudflare/quiche"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/cloudflare/${PN}.git"
	inherit git-r3
else
	GIT_COMMIT="89d0317ffb5b12080a41aea2743272aac887eecd"
	BORINGSSL_COMMIT="f18bd55240b229a65df48e7905da98fff18cbf59"
	SRC_URI="https://github.com/cloudflare/${PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz
		https://github.com/google/boringssl/archive/${BORINGSSL_COMMIT}.zip -> boringssl-${BORINGSSL_COMMIT}.tar.gz"
	S="${WORKDIR}/${PN}-${GIT_COMMIT}"
	SRC_URI+=" $(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0/0"
IUSE=""
DOCS=( CODEOWNERS  COPYING README.md )

BDEPEND="
	>=virtual/rust-1.35.0
	dev-util/cmake
	dev-lang/go
"
DEPEND=""
RDEPEND=""

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
		tar -xf "${DISTDIR}/boringssl-${BORINGSSL_COMMIT}.tar.gz" -C "${S}/deps/boringssl" || die
	fi
}

src_prepare(){
	default
	multilib_copy_sources
}

multilib_src_compile(){
	cargo_src_compile --features pkg-config-meta
}

multilib_src_test(){
	cargo_src_test
}

multilib_src_install() {
	sed -i -e "s:libdir=.\+:libdir=${EPREFIX}/usr/$(get_libdir):" -e "s:includedir=.\+:includedir=${EPREFIX}/usr/include:" target/release/quiche.pc || die
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins target/release/quiche.pc
	doheader -r include/*
	dolib.so target/release/libquiche.so
}
