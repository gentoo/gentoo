# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.7.6
ansi_term-0.11.0
arrayref-0.3.5
arrayvec-0.5.1
atty-0.2.13
autocfg-0.1.7
bincode-1.2.0
bitflags-1.2.1
blake2b_simd-0.5.9
bstr-0.2.8
byteorder-1.3.2
c2-chacha-0.2.3
cargo_toml-0.6.4
cast-0.2.2
cbindgen-0.9.1
cc-1.0.47
cfg-if-0.1.10
clap-2.33.0
cloudabi-0.0.3
cmake-0.1.42
constant_time_eq-0.1.4
cranelift-bforest-0.44.0
cranelift-codegen-0.44.0
cranelift-codegen-meta-0.44.0
cranelift-codegen-shared-0.44.0
cranelift-entity-0.44.0
cranelift-native-0.44.0
criterion-0.2.11
criterion-plot-0.3.1
crossbeam-deque-0.7.2
crossbeam-epoch-0.8.0
crossbeam-queue-0.1.2
crossbeam-utils-0.6.6
crossbeam-utils-0.7.0
csv-1.1.1
csv-core-0.1.6
ctor-0.1.12
digest-0.8.1
dynasm-0.5.1
dynasmrt-0.5.1
either-1.5.3
enum-methods-0.0.8
erased-serde-0.3.9
errno-0.2.4
errno-dragonfly-0.1.1
failure-0.1.6
failure_derive-0.1.6
fuchsia-cprng-0.1.1
gcc-0.3.55
generational-arena-0.2.4
generic-array-0.12.3
getrandom-0.1.13
ghost-0.1.1
glob-0.2.11
glob-0.3.0
goblin-0.0.24
heck-0.3.1
hermit-abi-0.1.3
hex-0.3.2
indexmap-1.3.0
inventory-0.1.4
inventory-impl-0.1.4
itertools-0.8.1
itoa-0.4.4
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.65
llvm-sys-80.1.1
lock_api-0.3.1
log-0.4.8
maybe-uninit-2.0.0
md5-0.6.1
memchr-2.2.1
memmap-0.7.0
memoffset-0.5.3
nix-0.15.0
num_cpus-1.11.0
num-traits-0.2.8
owning_ref-0.4.0
page_size-0.4.1
parking_lot-0.9.0
parking_lot_core-0.6.2
plain-0.2.3
ppv-lite86-0.2.6
proc-macro2-0.4.30
proc-macro2-1.0.6
proc-macro-error-0.2.6
quote-0.3.15
quote-0.6.13
quote-1.0.2
rand-0.7.2
rand_chacha-0.2.1
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_hc-0.2.0
rand_os-0.1.3
rand_xoshiro-0.1.0
raw-cpuid-6.1.0
rayon-1.2.0
rayon-core-1.6.0
rdrand-0.4.0
redox_syscall-0.1.56
regex-1.3.1
regex-automata-0.1.8
regex-syntax-0.6.12
remove_dir_all-0.5.2
rustc_version-0.2.3
ryu-1.0.2
same-file-1.0.5
scopeguard-1.0.0
scroll-0.9.2
scroll_derive-0.9.5
semver-0.9.0
semver-parser-0.7.0
serde-1.0.102
serde-bench-0.0.7
serde_bytes-0.11.2
serde_derive-1.0.102
serde_json-1.0.41
smallvec-0.6.13
stable_deref_trait-1.1.1
strsim-0.8.0
structopt-0.3.4
structopt-derive-0.3.4
syn-0.11.11
syn-0.15.44
syn-1.0.8
synom-0.11.3
synstructure-0.12.2
target-lexicon-0.8.1
tempfile-3.1.0
textwrap-0.11.0
thread_local-0.3.6
time-0.1.42
tinytemplate-1.0.2
toml-0.4.10
toml-0.5.5
typenum-1.11.2
typetag-0.1.4
typetag-impl-0.1.4
unicode-segmentation-1.6.0
unicode-width-0.1.6
unicode-xid-0.0.4
unicode-xid-0.1.0
unicode-xid-0.2.0
vec_map-0.8.1
void-1.0.2
wabt-0.9.2
wabt-sys-0.7.0
walkdir-2.2.9
wasi-0.7.0
wasmer-clif-fork-frontend-0.44.0
wasmer-clif-fork-wasm-0.44.0
wasmparser-0.39.2
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="universal web assembly runtime"
HOMEPAGE="https://wasmer.io"
SRC_URI="https://github.com/wasmerio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
https://dev.gentoo.org/~williamh/dist/${P}-git-deps.tar.xz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MIT Apache-2.0 BSD-2 ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="
	dev-util/cmake
	>=virtual/rust-1.37.0
"

src_prepare() {
	[[ "${PV}" == *9999* ]] || ln -s ../${P}-git-deps "${ECARGO_HOME}"/git
	default
}

src_install() {
	cargo_src_install --path=.
	einstalldocs
}
