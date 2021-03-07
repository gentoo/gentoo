# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
abscissa_core-0.5.2
abscissa_derive-0.5.0
addr2line-0.13.0
adler-0.2.3
aho-corasick-0.7.14
ansi_term-0.11.0
arc-swap-0.4.7
arrayref-0.3.6
arrayvec-0.5.2
ascii-0.9.3
atty-0.2.14
autocfg-1.0.1
backtrace-0.3.53
base64-0.12.3
bitflags-1.2.1
blake2b_simd-0.5.10
block-buffer-0.7.3
block-padding-0.1.5
bumpalo-3.4.0
byteorder-1.3.4
bytes-0.5.6
byte-tools-0.3.1
canonical-path-2.0.2
cargo-edit-0.7.0
cargo-lock-6.0.0
cargo_metadata-0.11.4
cc-1.0.61
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clap-2.33.3
color-backtrace-0.3.0
combine-3.8.1
constant_time_eq-0.1.5
core-foundation-0.7.0
core-foundation-sys-0.7.0
crates-index-0.16.0
crossbeam-utils-0.7.2
cvss-1.0.0
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
digest-0.8.1
dirs-3.0.1
dirs-sys-0.3.5
dtoa-0.4.6
either-1.6.1
encoding_rs-0.8.24
env_proxy-0.4.1
error-chain-0.12.4
failure-0.1.8
failure_derive-0.1.8
fake-simd-0.1.2
fixedbitset-0.2.0
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
fs-err-2.5.0
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-channel-0.3.7
futures-core-0.3.7
futures-io-0.3.7
futures-sink-0.3.7
futures-task-0.3.7
futures-util-0.3.7
generational-arena-0.2.8
generic-array-0.12.3
getrandom-0.1.15
gimli-0.22.0
git2-0.13.12
glob-0.3.0
gumdrop-0.7.0
gumdrop_derive-0.7.0
h2-0.2.7
hashbrown-0.9.1
heck-0.3.1
hermit-abi-0.1.17
hex-0.4.2
home-0.5.3
http-0.2.1
httparse-1.3.4
http-body-0.3.1
httpdate-0.3.2
hyper-0.13.8
hyper-tls-0.4.3
ident_case-1.0.1
idna-0.2.0
indexmap-1.6.0
iovec-0.1.4
ipnet-2.3.0
itoa-0.4.6
jobserver-0.1.21
js-sys-0.3.45
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.80
libgit2-sys-0.12.14+1.1.0
libssh2-sys-0.2.19
libz-sys-1.1.2
linked-hash-map-0.5.3
log-0.4.11
maplit-1.0.2
matchers-0.0.1
matches-0.1.8
maybe-uninit-2.0.0
memchr-2.3.3
mime-0.3.16
mime_guess-2.0.3
miniz_oxide-0.4.3
mio-0.6.22
miow-0.2.1
native-tls-0.2.4
net2-0.2.35
num_cpus-1.13.0
num-integer-0.1.43
num-traits-0.2.12
object-0.21.1
once_cell-1.4.1
opaque-debug-0.2.3
openssl-0.10.30
openssl-probe-0.1.2
openssl-src-111.12.0+1.1.1h
openssl-sys-0.9.58
owning_ref-0.4.1
percent-encoding-2.1.0
pest-2.1.3
pest_derive-2.1.0
pest_generator-2.1.3
pest_meta-2.1.3
petgraph-0.5.1
pin-project-0.4.27
pin-project-1.0.1
pin-project-internal-0.4.27
pin-project-internal-1.0.1
pin-project-lite-0.1.11
pin-utils-0.1.0
pkg-config-0.3.19
platforms-1.0.2
ppv-lite86-0.2.9
proc-macro2-1.0.24
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.57
redox_users-0.3.5
regex-1.4.1
regex-automata-0.1.9
regex-syntax-0.6.20
remove_dir_all-0.5.3
reqwest-0.10.8
rust-argon2-0.8.2
rustc-demangle-0.1.18
rustsec-0.22.2
ryu-1.0.5
schannel-0.1.19
secrecy-0.6.0
security-framework-0.4.4
security-framework-sys-0.4.3
semver-0.10.0
semver-0.11.0
semver-0.9.0
semver-parser-0.10.0
semver-parser-0.7.0
serde-1.0.117
serde_derive-1.0.117
serde_json-1.0.59
serde_urlencoded-0.6.1
sha-1-0.8.2
signal-hook-0.1.16
signal-hook-registry-1.2.1
slab-0.4.2
smallvec-0.6.13
smartstring-0.2.5
smol_str-0.1.16
socket2-0.3.15
stable_deref_trait-1.2.0
static_assertions-1.1.0
strsim-0.8.0
strsim-0.9.3
structopt-0.3.20
structopt-derive-0.4.13
subprocess-0.2.6
syn-1.0.48
synstructure-0.12.4
tempfile-3.1.0
termcolor-1.1.0
textwrap-0.11.0
thiserror-1.0.21
thiserror-impl-1.0.21
thread_local-1.0.1
time-0.1.44
tinyvec-0.3.4
tokio-0.2.22
tokio-tls-0.3.1
tokio-util-0.3.1
toml-0.5.7
toml_edit-0.2.0
tower-service-0.3.0
tracing-0.1.21
tracing-attributes-0.1.11
tracing-core-0.1.17
tracing-futures-0.2.4
tracing-log-0.1.1
tracing-subscriber-0.1.6
try-lock-0.2.3
typenum-1.12.0
ucd-trie-0.1.3
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.13
unicode-segmentation-1.6.0
unicode-width-0.1.8
unicode-xid-0.2.1
unreachable-1.0.0
url-2.1.1
vcpkg-0.2.10
vec_map-0.8.2
version_check-0.9.2
void-1.0.2
wait-timeout-0.2.0
want-0.3.0
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.68
wasm-bindgen-backend-0.2.68
wasm-bindgen-futures-0.4.18
wasm-bindgen-macro-0.2.68
wasm-bindgen-macro-support-0.2.68
wasm-bindgen-shared-0.2.68
web-sys-0.3.45
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.7.0
ws2_32-sys-0.2.1
zeroize-1.1.1
"

inherit cargo

DESCRIPTION="Audit Cargo.lock for security vulnerabilities"
HOMEPAGE="https://github.com/rustsec/cargo-audit"
SRC_URI="https://github.com/RustSec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="fix libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-libs/libgit2:=
"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

# requires checkout of vuln db/network
RESTRICT="test"

src_prepare() {
	default
	pushd "${ECARGO_HOME}/gentoo/openssl-sys-"* > /dev/null || die
	eapply -p3 "${FILESDIR}/${PV}-libressl.patch"
	popd > /dev/null || die
}

src_configuire() {
	local myfeatures=( $(usev fix) )
	cargo_src_configure
}

src_install() {
	cargo_src_install
	einstalldocs
	dodoc audit.toml.example
}
