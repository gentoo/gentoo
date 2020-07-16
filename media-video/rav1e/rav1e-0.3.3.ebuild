# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.12.1
adler32-1.0.4
aho-corasick-0.7.10
ansi_term-0.11.0
aom-sys-0.1.4
arbitrary-0.2.0
arc-swap-0.4.7
arg_enum_proc_macro-0.3.0
arrayvec-0.5.1
assert_cmd-1.0.1
atty-0.2.14
autocfg-1.0.0
backtrace-0.3.48
bindgen-0.53.3
bindgen-0.54.0
bitflags-1.2.1
bitstream-io-0.8.5
bstr-0.2.13
bumpalo-3.4.0
bytemuck-1.2.0
byteorder-1.3.4
cast-0.2.3
cc-1.0.54
cexpr-0.4.0
cfg-if-0.1.10
chrono-0.4.11
clang-sys-0.29.3
clap-2.33.1
cmake-0.1.44
console-0.11.3
crc32fast-1.2.0
criterion-0.3.2
criterion-plot-0.4.2
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.2.2
crossbeam-utils-0.7.2
csv-1.1.3
csv-core-0.1.10
ctor-0.1.14
dav1d-sys-0.3.2
deflate-0.8.4
difference-2.0.0
doc-comment-0.3.3
either-1.5.3
encode_unicode-0.3.6
env_logger-0.7.1
error-chain-0.10.0
fern-0.6.0
getrandom-0.1.14
gimli-0.21.0
glob-0.3.0
hermit-abi-0.1.13
humantime-1.3.0
image-0.23.4
inflate-0.4.5
interpolate_name-0.2.3
itertools-0.8.2
itertools-0.9.0
itoa-0.4.5
ivf-0.1.0
jobserver-0.1.21
js-sys-0.3.40
lazycell-1.2.1
lazy_static-1.4.0
libc-0.2.71
libloading-0.5.2
log-0.4.8
maybe-uninit-2.0.0
memchr-2.3.3
memoffset-0.5.4
metadeps-1.1.2
nasm-rs-0.1.7
nom-5.1.1
noop_proc_macro-0.2.1
num_cpus-1.13.0
num-derive-0.3.0
num-integer-0.1.42
num-iter-0.1.40
num-rational-0.2.4
num-traits-0.2.11
object-0.19.0
oorandom-11.1.1
output_vt100-0.1.2
paste-0.1.16
paste-impl-0.1.16
peeking_take_while-0.1.2
pkg-config-0.3.17
plotters-0.2.15
png-0.16.4
ppv-lite86-0.2.8
predicates-1.0.4
predicates-core-1.0.0
predicates-tree-1.0.0
pretty_assertions-0.6.1
proc-macro2-1.0.18
proc-macro-hack-0.5.16
quick-error-1.2.3
quote-1.0.6
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
rav1e-0.3.3
rayon-1.3.0
rayon-core-1.7.0
regex-1.3.9
regex-automata-0.1.9
regex-syntax-0.6.18
rustc-demangle-0.1.16
rustc-hash-1.1.0
rustc_version-0.2.3
rust_hawktracer-0.7.0
rust_hawktracer_normal_macro-0.4.1
rust_hawktracer_proc_macro-0.4.1
rust_hawktracer_sys-0.4.2
ryu-1.0.5
same-file-1.0.6
scan_fmt-0.2.5
scopeguard-1.1.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.111
serde_derive-1.0.111
serde_json-1.0.53
shlex-0.1.1
signal-hook-0.1.15
signal-hook-registry-1.2.0
simd_helpers-0.1.0
strsim-0.8.0
syn-1.0.30
termcolor-1.1.0
terminal_size-0.1.12
termios-0.3.2
textwrap-0.11.0
thiserror-1.0.19
thiserror-impl-1.0.19
thread_local-1.0.1
time-0.1.43
tinytemplate-1.1.0
toml-0.2.1
toml-0.5.6
treeline-0.1.0
unicode-width-0.1.7
unicode-xid-0.2.0
vec_map-0.8.2
vergen-3.1.0
version_check-0.9.2
wait-timeout-0.2.0
walkdir-2.3.1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.63
wasm-bindgen-backend-0.2.63
wasm-bindgen-macro-0.2.63
wasm-bindgen-macro-support-0.2.63
wasm-bindgen-shared-0.2.63
web-sys-0.3.40
which-3.1.1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
y4m-0.5.3
"

inherit cargo

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/xiph/rav1e.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/xiph/rav1e/archive/v${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris ${CRATES})
		"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
fi

DESCRIPTION="The fastest and safest AV1 encoder"
HOMEPAGE="https://github.com/xiph/rav1e/"
RESTRICT=""
LICENSE="BSD-2 Apache-2.0 MIT Unlicense"
SLOT="0"

IUSE="+capi"

ASM_DEP=">=dev-lang/nasm-2.14"
DEPEND="amd64? ( ${ASM_DEP} )"
RDEPEND="capi? ( dev-util/cargo-c )"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		default
		cargo_src_unpack
	fi
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	local args=$(usex debug "" --release)

	cargo build ${args} \
		|| die "cargo build failed"

	if use capi; then
		cargo cbuild ${args} \
			--prefix="/usr" --libdir="/usr/$(get_libdir)" --destdir="${ED}" \
			|| die "cargo cbuild failed"
	fi
}

src_install() {
	export CARGO_HOME="${ECARGO_HOME}"
	local args=$(usex debug "" --release)

	if use capi; then
		cargo cinstall $args \
			--prefix="/usr" --libdir="/usr/$(get_libdir)" --destdir="${ED}" \
			|| die "cargo cinstall failed"
	fi

	cargo_src_install
}
