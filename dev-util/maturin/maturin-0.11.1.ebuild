# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.15.2
adler-1.0.2
aes-0.6.0
aes-soft-0.6.4
aesni-0.10.0
aho-corasick-0.7.18
ansi_term-0.11.0
anyhow-1.0.42
atty-0.2.14
autocfg-1.0.1
backtrace-0.3.60
base64-0.10.1
base64-0.13.0
bitflags-1.2.1
block-buffer-0.9.0
block-modes-0.7.0
block-padding-0.2.1
bumpalo-3.7.0
byteorder-1.4.3
bytes-1.0.1
bytesize-1.0.1
bzip2-0.4.3
bzip2-sys-0.1.11+1.0.8
camino-1.0.4
cargo-platform-0.1.1
cargo_metadata-0.14.0
cbindgen-0.19.0
cc-1.0.68
cfg-if-1.0.0
charset-0.1.2
cipher-0.2.5
clap-2.33.3
configparser-2.1.0
core-foundation-0.7.0
core-foundation-sys-0.7.0
cpufeatures-0.1.5
crc32fast-1.2.1
crypto-mac-0.10.0
dbus-0.2.3
digest-0.9.0
dirs-3.0.2
dirs-sys-0.3.6
encoding_rs-0.8.28
env_logger-0.7.1
fat-macho-0.4.4
filetime-0.2.14
flate2-1.0.20
fnv-1.0.7
form_urlencoded-1.0.1
fs-err-2.6.0
futures-channel-0.3.15
futures-core-0.3.15
futures-io-0.3.15
futures-macro-0.3.15
futures-sink-0.3.15
futures-task-0.3.15
futures-util-0.3.15
generic-array-0.14.4
getrandom-0.1.16
getrandom-0.2.3
gimli-0.24.0
glob-0.3.0
goblin-0.4.2
h2-0.3.3
hashbrown-0.11.2
heck-0.3.3
hermit-abi-0.1.19
hkdf-0.10.0
hmac-0.10.1
http-0.2.4
http-body-0.4.2
httparse-1.4.1
httpdate-1.0.1
human-panic-1.0.3
humantime-1.3.0
hyper-0.14.10
hyper-rustls-0.22.1
idna-0.2.3
indexmap-1.7.0
indoc-1.0.3
ipnet-2.3.1
itoa-0.4.7
js-sys-0.3.51
keyring-0.10.1
lazy_static-1.4.0
libc-0.2.98
log-0.4.14
mailparse-0.13.4
matches-0.1.8
memchr-2.4.0
mime-0.3.16
mime_guess-2.0.3
miniz_oxide-0.4.4
mio-0.7.13
miow-0.3.7
ntapi-0.3.6
num-0.3.1
num-bigint-0.3.2
num-complex-0.3.1
num-integer-0.1.44
num-iter-0.1.42
num-rational-0.3.2
num-traits-0.2.14
num_cpus-1.13.0
object-0.25.3
once_cell-1.8.0
opaque-debug-0.3.0
os_type-2.3.0
percent-encoding-2.1.0
pin-project-lite-0.2.7
pin-utils-0.1.0
pkg-config-0.3.19
plain-0.2.3
platform-info-0.1.0
ppv-lite86-0.2.10
pretty_env_logger-0.4.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.19
proc-macro-nested-0.1.7
proc-macro2-1.0.27
pyproject-toml-0.1.1
python-pkginfo-0.4.0
quick-error-1.2.3
quote-1.0.9
quoted_printable-0.4.3
rand-0.7.3
rand-0.8.4
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_core-0.5.1
rand_core-0.6.3
rand_hc-0.2.0
rand_hc-0.3.1
redox_syscall-0.2.9
redox_users-0.4.0
regex-1.5.4
regex-syntax-0.6.25
remove_dir_all-0.5.3
reqwest-0.11.4
ring-0.16.20
rpassword-5.0.1
rustc-demangle-0.1.20
rustls-0.19.1
ryu-1.0.5
same-file-1.0.6
scroll-0.10.2
scroll_derive-0.10.5
sct-0.6.1
secret-service-1.1.3
security-framework-0.4.4
security-framework-sys-0.4.3
semver-1.0.3
serde-1.0.126
serde_derive-1.0.126
serde_json-1.0.64
serde_urlencoded-0.7.0
sha2-0.9.5
shlex-1.0.0
slab-0.4.3
socket2-0.4.0
spin-0.5.2
strsim-0.8.0
structopt-0.3.22
structopt-derive-0.4.15
subtle-2.4.0
syn-1.0.73
tar-0.4.35
target-lexicon-0.12.0
tempfile-3.2.0
termcolor-1.1.2
textwrap-0.11.0
thiserror-1.0.26
thiserror-impl-1.0.26
time-0.1.43
tinyvec-1.2.0
tinyvec_macros-0.1.0
tokio-1.8.1
tokio-rustls-0.22.0
tokio-util-0.6.7
toml-0.5.8
tower-service-0.3.1
tracing-0.1.26
tracing-core-0.1.18
try-lock-0.2.3
typenum-1.13.0
unicase-2.6.0
unicode-bidi-0.3.5
unicode-normalization-0.1.19
unicode-segmentation-1.8.0
unicode-width-0.1.8
unicode-xid-0.2.2
unindent-0.1.7
untrusted-0.7.1
url-2.2.2
uuid-0.8.2
vec_map-0.8.2
version_check-0.9.3
walkdir-2.3.2
want-0.3.0
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.74
wasm-bindgen-backend-0.2.74
wasm-bindgen-futures-0.4.24
wasm-bindgen-macro-0.2.74
wasm-bindgen-macro-support-0.2.74
wasm-bindgen-shared-0.2.74
web-sys-0.3.51
webpki-0.21.4
webpki-roots-0.21.1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.7.0
xattr-0.2.2
zip-0.5.13
"
CRATES_TEST="
ctor-0.1.19
ctor-0.1.20
ghost-0.1.2
indoc-0.3.6
indoc-impl-0.3.6
instant-0.1.9
inventory-0.1.10
inventory-impl-0.1.10
libc-0.2.86
libc-0.2.90
libc-0.2.92
lock_api-0.4.2
lock_api-0.4.3
parking_lot-0.11.1
parking_lot_core-0.8.3
paste-0.1.18
paste-impl-0.1.18
proc-macro2-1.0.24
proc-macro2-1.0.26
pyo3-0.14.0
pyo3-build-config-0.14.0
pyo3-macros-0.14.0
pyo3-macros-backend-0.14.0
redox_syscall-0.2.5
scopeguard-1.1.0
smallvec-1.6.1
syn-1.0.60
syn-1.0.64
syn-1.0.68
unicode-xid-0.2.1
"
PYTHON_COMPAT=( python3_{8,9} )

inherit cargo python-any-r1

DESCRIPTION="Build and publish crates with pyo3, rust-cpython and cffi bindings"
HOMEPAGE="https://github.com/PyO3/maturin"
SRC_URI="https://github.com/PyO3/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	test? ( $(cargo_crate_uris ${CRATES_TEST}) )"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
PROPERTIES="test_network"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="test? (
		$(python_gen_any_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
			dev-python/pycparser[${PYTHON_USEDEP}]
		')
	)"
BDEPEND=""

QA_FLAGS_IGNORED="usr/bin/maturin"

python_check_deps() {
	has_version -d "dev-python/cffi[${PYTHON_USEDEP}]" &&
	has_version -d "dev-python/pycparser[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_install() {
	cargo_src_install
	dodoc Readme.md
}

src_test() {
	cargo_src_test -- --skip locked_doesnt_build_without_cargo_lock
}
