# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
Inflector-0.11.4
ahash-0.7.6
aho-corasick-0.7.18
annotate-snippets-0.9.1
ansi_term-0.11.0
anyhow-1.0.48
ascii-canvas-3.0.0
atty-0.2.14
autocfg-1.0.1
beef-0.4.4
bitflags-1.3.2
bit-set-0.5.2
bit-vec-0.6.3
bstr-0.2.17
bumpalo-3.8.0
cast-0.2.7
cc-1.0.72
cfg-if-1.0.0
clap-2.33.3
convert_case-0.4.0
criterion-0.3.5
criterion-plot-0.4.4
crossbeam-channel-0.5.1
crossbeam-deque-0.8.1
crossbeam-epoch-0.9.5
crossbeam-utils-0.8.5
crunchy-0.2.2
csv-1.1.6
csv-core-0.1.10
debugserver-types-0.5.0
derivative-2.2.0
derive_more-0.99.16
diff-0.1.12
dirs-next-2.0.0
dirs-sys-next-0.1.2
either-1.6.1
ena-0.14.0
fixedbitset-0.2.0
fnv-1.0.7
form_urlencoded-1.0.1
fs2-0.4.3
gazebo-0.2.2
gazebo-0.4.4
gazebo_derive-0.1.1
gazebo_derive-0.4.1
getrandom-0.2.3
half-1.8.2
hashbrown-0.11.2
heck-0.3.3
hermit-abi-0.1.19
idna-0.2.3
indenter-0.3.3
indexmap-1.7.0
indoc-1.0.3
instant-0.1.12
itertools-0.9.0
itertools-0.10.1
itoa-0.4.8
js-sys-0.3.55
lalrpop-0.19.6
lalrpop-util-0.19.6
lazy_static-1.4.0
libc-0.2.108
lock_api-0.4.5
logos-0.11.4
logos-derive-0.11.5
log-0.4.14
lsp-server-0.5.2
lsp-types-0.89.2
maplit-1.0.2
matches-0.1.9
memchr-2.4.1
memoffset-0.6.4
new_debug_unreachable-1.0.4
nix-0.19.1
num-traits-0.2.14
num_cpus-1.13.0
once_cell-1.8.0
oorandom-11.1.3
parking_lot-0.11.2
parking_lot_core-0.8.5
paste-1.0.6
percent-encoding-2.1.0
pest-2.1.3
petgraph-0.5.1
phf_shared-0.8.0
pico-args-0.4.2
plotters-0.3.1
plotters-backend-0.3.2
plotters-svg-0.3.1
precomputed-hash-0.1.1
proc-macro2-1.0.32
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
quote-1.0.10
rayon-1.5.1
rayon-core-1.9.1
redox_syscall-0.2.10
redox_users-0.4.0
regex-1.5.4
regex-automata-0.1.10
regex-syntax-0.6.25
rustc_version-0.3.3
rustc_version-0.4.0
rustversion-1.0.5
rustyline-7.1.0
ryu-1.0.5
same-file-1.0.6
schemafy-0.5.2
schemafy_core-0.5.2
schemafy_lib-0.5.2
scopeguard-1.1.0
semver-0.11.0
semver-1.0.4
semver-parser-0.10.2
serde-1.0.130
serde_cbor-0.11.2
serde_derive-1.0.130
serde_json-1.0.71
serde_repr-0.1.7
siphasher-0.3.7
smallvec-1.7.0
smawk-0.3.1
starlark-0.6.0
starlark_derive-0.6.0
static_assertions-1.1.0
string_cache-0.8.2
strsim-0.8.0
strsim-0.10.0
structopt-0.3.25
structopt-derive-0.4.18
syn-1.0.81
term-0.7.0
textwrap-0.11.0
textwrap-0.14.2
thiserror-1.0.30
thiserror-impl-1.0.30
tinytemplate-1.2.1
tinyvec-1.5.1
tinyvec_macros-0.1.0
tiny-keccak-2.0.2
ucd-trie-0.1.3
unicode-bidi-0.3.7
unicode-linebreak-0.1.2
unicode-normalization-0.1.19
unicode-segmentation-1.8.0
unicode-width-0.1.9
unicode-xid-0.2.2
unindent-0.1.7
url-2.2.2
utf8parse-0.2.0
utf8-ranges-1.0.4
vec_map-0.8.2
version_check-0.9.3
walkdir-2.3.2
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.78
wasm-bindgen-backend-0.2.78
wasm-bindgen-macro-0.2.78
wasm-bindgen-macro-support-0.2.78
wasm-bindgen-shared-0.2.78
web-sys-0.3.55
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
yansi-term-0.1.2
"

inherit cargo

DESCRIPTION="A Rust implementation of the Starlark language"
HOMEPAGE="https://github.com/facebookexperimental/starlark-rust"
SRC_URI="$(cargo_crate_uris ${CRATES})
	https://github.com/facebookexperimental/starlark-rust/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# Nightly rust-1.53.0 required for https://bugs.gentoo.org/796824
BDEPEND="${RUST_DEPEND}
	>=dev-lang/rust-1.53.0[nightly]"

# RUSTFLAGS support needed: https://bugs.gentoo.org/796887
QA_FLAGS_IGNORED=".*"

src_prepare() {
	sed -e 's:#!\[feature(const_mut_refs)\]:\0\n#![feature(const_panic)]:' \
		-i starlark/src/lib.rs || die
	default
}

src_test() {
	source "${FILESDIR}/test/features.bash" || die
	test-features_main "${PWD}/target/release/starlark" || die
}

src_install() {
	dobin target/release/starlark
	ln "${ED}/usr/bin/starlark"{,-rust} || die
	dodoc -r {docs,{CHANGELOG,README}.md}
}
