# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.12.2
adler32-1.1.0
aes-0.3.2
aes-soft-0.3.3
aesni-0.6.0
aho-corasick-0.7.13
ansi_term-0.11.0
async-compression-0.3.5
atty-0.2.14
autocfg-0.1.7
autocfg-1.0.0
backtrace-0.3.49
base64-0.11.0
base64-0.12.3
bitfield-0.13.2
bitflags-1.2.1
block-buffer-0.7.3
block-cipher-trait-0.6.2
block-modes-0.3.3
block-padding-0.1.5
blowfish-0.4.0
buf_redux-0.8.4
bumpalo-3.4.0
byte-tools-0.3.1
byteorder-1.3.4
bytes-0.5.5
cast5-0.6.0
cc-1.0.55
cfb-mode-0.3.2
cfg-if-0.1.10
chrono-0.4.11
circular-0.3.0
clap-2.33.1
clear_on_drop-0.2.4
core-foundation-0.7.1
core-foundation-sys-0.7.1
crc24-0.1.6
crc32fast-1.2.0
curl-0.4.30
curl-sys-0.4.32+curl-7.70.0
curve25519-dalek-2.1.0
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
derive_builder-0.9.0
derive_builder_core-0.9.0
des-0.3.0
digest-0.8.1
dtoa-0.4.6
ed25519-dalek-1.0.0-pre.3
effective-limits-0.5.1
encoding_rs-0.8.23
env_proxy-0.4.1
error-chain-0.12.2
failure-0.1.8
failure_derive-0.1.8
fake-simd-0.1.2
filetime-0.2.10
flate2-1.0.14
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-channel-0.3.5
futures-core-0.3.5
futures-io-0.3.5
futures-sink-0.3.5
futures-task-0.3.5
futures-util-0.3.5
generator-0.6.21
generic-array-0.12.3
getrandom-0.1.14
gimli-0.21.0
git-testament-0.1.9
git-testament-derive-0.1.10
h2-0.2.5
hermit-abi-0.1.14
hex-0.4.2
http-0.2.1
http-body-0.3.1
httparse-1.3.4
hyper-0.13.6
hyper-tls-0.4.1
ident_case-1.0.1
idna-0.2.0
indexmap-1.4.0
iovec-0.1.4
itoa-0.4.6
js-sys-0.3.40
keccak-0.1.0
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.71
libm-0.2.1
libz-sys-1.0.25
log-0.4.8
loom-0.3.4
lzma-sys-0.1.16
matches-0.1.8
md-5-0.8.0
memchr-2.3.3
mime-0.3.16
mime_guess-2.0.3
miniz_oxide-0.3.7
mio-0.6.22
miow-0.2.1
native-tls-0.2.4
net2-0.2.34
nom-4.2.3
num-bigint-dig-0.6.0
num-derive-0.3.0
num-integer-0.1.43
num-iter-0.1.41
num-traits-0.2.12
num_cpus-1.13.0
object-0.20.0
once_cell-1.4.0
opaque-debug-0.2.3
opener-0.4.1
openssl-0.10.30
openssl-probe-0.1.2
openssl-sys-0.9.58
openssl-src-111.10.0+1.1.1g
percent-encoding-2.1.0
pgp-0.5.2
pin-project-0.4.22
pin-project-internal-0.4.22
pin-project-lite-0.1.7
pin-utils-0.1.0
pkg-config-0.3.17
ppv-lite86-0.2.8
proc-macro2-1.0.18
pulldown-cmark-0.7.1
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
regex-1.3.9
regex-syntax-0.6.18
remove_dir_all-0.5.3
reqwest-0.10.6
retry-1.0.0
ripemd160-0.8.0
rs_tracing-1.0.1
rsa-0.2.0
rustc-demangle-0.1.16
rustc_version-0.2.3
ryu-1.0.5
safemem-0.3.3
same-file-1.0.6
schannel-0.1.19
scoped-tls-0.1.2
scopeguard-1.1.0
security-framework-0.4.4
security-framework-sys-0.4.3
semver-0.9.0
semver-parser-0.7.0
serde-1.0.114
serde_derive-1.0.114
serde_json-1.0.55
serde_urlencoded-0.6.1
sha-1-0.8.2
sha2-0.8.2
sha3-0.8.2
slab-0.4.2
smallvec-1.4.0
socket2-0.3.12
spin-0.5.2
stream-cipher-0.3.2
strsim-0.10.0
strsim-0.8.0
strsim-0.9.3
subtle-2.2.3
syn-1.0.33
synstructure-0.12.4
sys-info-0.6.1
tar-0.4.29
tempfile-3.1.0
term-0.5.1
textwrap-0.11.0
thiserror-1.0.20
thiserror-impl-1.0.20
thread_local-1.0.1
threadpool-1.8.1
time-0.1.43
tinyvec-0.3.3
tokio-0.2.21
tokio-tls-0.3.1
tokio-util-0.3.1
toml-0.5.6
tower-service-0.3.0
try-lock-0.2.2
try_from-0.3.2
twofish-0.2.0
typenum-1.12.0
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.13
unicode-width-0.1.7
unicode-xid-0.2.1
url-2.1.1
vcpkg-0.2.10
vec_map-0.8.2
version_check-0.1.5
version_check-0.9.2
wait-timeout-0.2.0
walkdir-2.3.1
want-0.3.0
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.63
wasm-bindgen-backend-0.2.63
wasm-bindgen-futures-0.4.13
wasm-bindgen-macro-0.2.63
wasm-bindgen-macro-support-0.2.63
wasm-bindgen-shared-0.2.63
web-sys-0.3.40
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.6.2
winreg-0.7.0
ws2_32-sys-0.2.1
x25519-dalek-0.6.0
xattr-0.2.2
xz2-0.1.6
zeroize-1.1.0
zeroize_derive-1.0.0
"

inherit bash-completion-r1 cargo prefix

HOME_CRATE_COMMIT="a243ee2fbee6022c57d56f5aa79aefe194eabe53"

DESCRIPTION="Rust toolchain installer"
HOMEPAGE="https://rust-lang.github.io/rustup/"
SRC_URI="https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rbtcollins/home/archive/${HOME_CRATE_COMMIT}.tar.gz -> ${P}_home_crate.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 MIT Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

# requires old libressl-2.5, so openssl only for now.
DEPEND="
	app-arch/xz-utils
	net-misc/curl:=[http2,ssl]
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="usr/bin/.*"

# uses network
RESTRICT="test"

src_prepare() {
	default
	# use portage-downloaded git checkout tarball
	sed -i "/^home =/s:.*:home = { path = \"../home-${HOME_CRATE_COMMIT}\" }:" Cargo.toml || die
}

src_compile() {
	export OPENSSL_NO_VENDOR=true
	cargo_src_compile --features no-self-update
}

src_install() {
	cargo_src_install --features no-self-update
	einstalldocs
	exeinto /usr/share/rustup
	newexe "$(prefixify_ro "${FILESDIR}"/symlink_rustup.sh)" symlink_rustup

	ln -s "${ED}/usr/bin/rustup-init" rustup || die
	./rustup completions bash rustup > "${T}/rustup" || die
	./rustup completions zsh rustup > "${T}/_rustup" || die

	dobashcomp "${T}/rustup"

	insinto /usr/share/zsh/site-functions
	doins "${T}/_rustup"
}

src_test() {
	cargo_src_test --features no-self-update
}

pkg_postinst() {
		einfo "No rustup toolchains installed by default"
		einfo "system rust toolchain can be added to rustup by running"
		einfo "helper script installed to ${EPREFIX}/usr/share/rustup/symlink_rustup"
		einfo "it will create proper symlinks in user home directory"
		einfo "and rustup updates will be managed by portage"
		einfo "please delete current rustup installation (if any) before running the script"
}
