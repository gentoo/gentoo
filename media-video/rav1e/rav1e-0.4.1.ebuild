# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.14.1
adler-1.0.2
adler32-1.2.0
aho-corasick-0.7.15
ansi_term-0.11.0
anyhow-1.0.40
aom-sys-0.2.2
arbitrary-0.4.7
arg_enum_proc_macro-0.3.1
arrayvec-0.5.2
assert_cmd-1.0.3
atty-0.2.14
autocfg-1.0.1
av-metrics-0.6.2
backtrace-0.3.56
bindgen-0.56.0
bitflags-1.2.1
bitmaps-2.1.0
bitstream-io-1.0.0
bstr-0.2.15
bumpalo-3.6.1
bytemuck-1.5.1
byteorder-1.4.3
bytesize-1.0.1
cargo-0.51.0
cargo-platform-0.1.1
cast-0.2.3
cbindgen-0.18.0
cc-1.0.67
cexpr-0.4.0
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clang-sys-1.1.1
clap-2.33.3
cmake-0.1.45
color_quant-1.1.0
commoncrypto-0.2.0
commoncrypto-sys-0.2.0
console-0.14.1
console_error_panic_hook-0.1.6
core-foundation-0.9.1
core-foundation-sys-0.8.2
crates-io-0.31.1
crc32fast-1.2.1
criterion-0.3.4
criterion-plot-0.4.3
crossbeam-0.8.0
crossbeam-channel-0.5.0
crossbeam-deque-0.8.0
crossbeam-epoch-0.9.3
crossbeam-queue-0.3.1
crossbeam-utils-0.8.3
crypto-hash-0.3.4
csv-1.1.6
csv-core-0.1.10
ctor-0.1.20
curl-0.4.35
curl-sys-0.4.41+curl-7.75.0
dav1d-sys-0.3.3
dcv-color-primitives-0.1.16
deflate-0.8.6
difference-2.0.0
doc-comment-0.3.3
either-1.6.1
encode_unicode-0.3.6
env_logger-0.8.3
fern-0.6.0
filetime-0.2.14
flate2-1.0.20
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.0.1
fwdansi-1.1.0
getrandom-0.2.2
gimli-0.23.0
git2-0.13.17
git2-curl-0.14.1
glob-0.3.0
globset-0.4.6
half-1.7.1
hashbrown-0.9.1
heck-0.3.2
hermit-abi-0.1.18
hex-0.3.2
hex-0.4.3
home-0.5.3
humantime-2.1.0
idna-0.2.2
ignore-0.4.17
im-rc-15.0.0
image-0.23.14
indexmap-1.6.2
interpolate_name-0.2.3
itertools-0.10.0
itertools-0.8.2
itertools-0.9.0
itoa-0.4.7
jobserver-0.1.21
js-sys-0.3.50
lab-0.8.2
lazy_static-1.4.0
lazycell-1.3.0
libc-0.2.92
libfuzzer-sys-0.3.5
libgit2-sys-0.12.18+1.1.0
libloading-0.7.0
libnghttp2-sys-0.1.6+1.43.0
libssh2-sys-0.2.21
libz-sys-1.1.2
log-0.4.14
matches-0.1.8
memchr-2.3.4
memoffset-0.6.3
miniz_oxide-0.3.7
miniz_oxide-0.4.4
miow-0.3.7
nasm-rs-0.2.0
nom-5.1.2
noop_proc_macro-0.3.0
num-derive-0.3.3
num-integer-0.1.44
num-iter-0.1.42
num-rational-0.3.2
num-traits-0.2.14
num_cpus-1.13.0
object-0.23.0
once_cell-1.7.2
oorandom-11.1.3
opener-0.4.1
openssl-0.10.33
openssl-probe-0.1.2
openssl-src-111.15.0+1.1.1k
openssl-sys-0.9.61
output_vt100-0.1.2
paste-1.0.5
peeking_take_while-0.1.2
percent-encoding-2.1.0
pest-2.1.3
pkg-config-0.3.19
plotters-0.3.0
plotters-backend-0.3.0
plotters-svg-0.3.0
png-0.16.8
ppv-lite86-0.2.10
predicates-1.0.7
predicates-core-1.0.2
predicates-tree-1.0.2
pretty_assertions-0.6.1
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.24
proc-macro2-1.0.26
quote-1.0.9
rand-0.8.3
rand_chacha-0.3.0
rand_core-0.5.1
rand_core-0.6.2
rand_hc-0.3.0
rand_xoshiro-0.4.0
rayon-1.5.0
rayon-core-1.9.0
redox_syscall-0.2.5
regex-1.4.5
regex-automata-0.1.9
regex-syntax-0.6.23
remove_dir_all-0.5.3
rust_hawktracer-0.7.0
rust_hawktracer_normal_macro-0.4.1
rust_hawktracer_proc_macro-0.4.1
rust_hawktracer_sys-0.4.2
rustc-demangle-0.1.18
rustc-hash-1.1.0
rustc-workspace-hack-1.0.0
rustc_version-0.2.3
rustc_version-0.3.3
rustfix-0.5.1
ryu-1.0.5
same-file-1.0.6
scan_fmt-0.2.6
schannel-0.1.19
scoped-tls-1.0.0
scopeguard-1.1.0
semver-0.10.0
semver-0.11.0
semver-0.9.0
semver-parser-0.10.2
semver-parser-0.7.0
serde-1.0.125
serde_cbor-0.11.1
serde_derive-1.0.125
serde_ignored-0.1.2
serde_json-1.0.64
shell-escape-0.1.5
shlex-0.1.1
signal-hook-0.3.7
signal-hook-registry-1.3.0
simd_helpers-0.1.0
sized-chunks-0.6.4
socket2-0.3.19
strip-ansi-escapes-0.1.0
strsim-0.8.0
structopt-0.3.21
structopt-derive-0.4.14
strum-0.20.0
strum_macros-0.20.1
syn-1.0.67
syn-1.0.68
system-deps-2.0.3
tar-0.4.33
tempfile-3.2.0
termcolor-1.1.2
terminal_size-0.1.16
textwrap-0.11.0
thiserror-1.0.24
thiserror-impl-1.0.24
thread_local-1.1.3
time-0.1.43
tinytemplate-1.2.1
tinyvec-1.1.1
tinyvec_macros-0.1.0
toml-0.5.8
treeline-0.1.0
typenum-1.13.0
ucd-trie-0.1.3
unicode-bidi-0.3.4
unicode-normalization-0.1.17
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.1
url-2.2.1
utf8parse-0.1.1
vcpkg-0.2.11
vec_map-0.8.2
version-compare-0.0.11
version_check-0.9.3
vte-0.3.3
wait-timeout-0.2.0
walkdir-2.3.2
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.73
wasm-bindgen-backend-0.2.73
wasm-bindgen-futures-0.4.23
wasm-bindgen-macro-0.2.73
wasm-bindgen-macro-support-0.2.73
wasm-bindgen-shared-0.2.73
wasm-bindgen-test-0.3.23
wasm-bindgen-test-macro-0.3.23
web-sys-0.3.50
which-3.1.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
y4m-0.7.0
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
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="The fastest and safest AV1 encoder"
HOMEPAGE="https://github.com/xiph/rav1e/"
RESTRICT=""
LICENSE="BSD-2 Apache-2.0 MIT Unlicense"
SLOT="0"

IUSE="+capi"

ASM_DEP=">=dev-lang/nasm-2.15"
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
