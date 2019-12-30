# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.5.3
aho-corasick-0.6.2
ansi_term-0.9.0
aster-0.38.0
atty-0.2.2
backtrace-0.3.0
backtrace-sys-0.1.10
bindgen-0.22.1
bitflags-0.4.0
bitflags-0.7.0
bitflags-0.8.0
byteorder-1.0.0
cexpr-0.2.0
cfg-if-0.1.0
clang-0.15.0
clang-sys-0.14.0
clap-2.21.1
crc-1.4.0
dbghelp-sys-0.2.0
docopt-0.7.0
dtoa-0.4.1
env_logger-0.3.5
env_logger-0.4.2
error-chain-0.9.0
flate2-0.2.17
gcc-0.3.43
glob-0.2.11
itoa-0.3.1
kernel32-sys-0.2.2
lazy_static-0.2.4
libc-0.2.21
libloading-0.3.2
linked-hash-map-0.3.0
linked-hash-map-0.4.1
log-0.3.7
memchr-0.1.11
memchr-1.0.1
miniz-sys-0.1.9
nix-0.7.0
nom-1.2.4
num-traits-0.1.37
num_cpus-1.3.0
ordered-float-0.4.0
pest-0.4.1
phf-0.7.21
phf_codegen-0.7.21
phf_generator-0.7.21
phf_shared-0.7.21
pkg-config-0.3.9
protobuf-1.2.2
quasi-0.29.0
quasi_codegen-0.29.0
quote-0.3.15
rand-0.3.15
regex-0.1.80
regex-0.2.1
regex-syntax-0.3.9
regex-syntax-0.4.0
rmp-0.8.5
rmpv-0.2.0
rustc-demangle-0.1.4
rustc-serialize-0.3.22
rustc_version-0.1.7
semver-0.1.20
serde-0.8.23
serde-0.9.11
serde-hjson-0.8.1
serde-value-0.4.0
serde_cbor-0.5.2
serde_codegen_internals-0.14.1
serde_derive-0.9.11
serde_json-0.9.9
serde_test-0.8.23
serde_yaml-0.6.2
siphasher-0.2.1
snap-0.2.1
strsim-0.6.0
syn-0.11.9
synom-0.11.3
syntex-0.54.0
syntex_errors-0.54.0
syntex_pos-0.54.0
syntex_syntax-0.54.0
target_build_utils-0.3.0
term-0.4.5
term_size-0.2.3
thread-id-2.0.0
thread-id-3.0.0
thread_local-0.2.7
thread_local-0.3.3
toml-0.3.1
unicode-segmentation-1.1.0
unicode-width-0.1.4
unicode-xid-0.0.4
unreachable-0.1.1
utf8-ranges-0.1.3
utf8-ranges-1.0.0
v8-0.9.6
v8-api-0.7.3
v8-sys-0.14.7
vec_map-0.7.0
void-1.0.2
winapi-0.2.8
winapi-build-0.1.1
xdg-basedir-1.0.0
yaml-rust-0.3.5
"

inherit cargo

DESCRIPTION="record query - a tool for doing record analysis and transformation"
HOMEPAGE="https://github.com/dflemstr/rq"
SRC_URI="https://github.com/dflemstr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	amd64? ( https://s3-eu-west-1.amazonaws.com/record-query/v8/x86_64-unknown-linux-gnu/5.6.222/v8-build.tar.gz -> ${PN}-v8-5.6.222-x86_64-build.tar.gz )
	x86? ( https://s3-eu-west-1.amazonaws.com/record-query/v8/i686-unknown-linux-gnu/5.6.222/v8-build.tar.gz -> ${PN}-v8-5.6.222-i686-build.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-devel/clang"

src_prepare() {
	default

	# point to bundled v8
	export V8_LIBS=${WORKDIR}/v8-build/lib/libv8uber.a
	export V8_SOURCE=${WORKDIR}/v8-build

	export LIBCLANG_PATH=$(dirname $(clang --print-file-name=libclang.so))
}

src_test() {
	cargo test || die "tests failed"
}

src_install() {
	cargo_src_install
	dodoc CONTRIBUTING.md README.md
}
