# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.13.0
adler-0.2.3
aes-0.5.0
aesni-0.8.0
aes-soft-0.5.0
aho-corasick-0.7.14
ansi_term-0.11.0
anyhow-1.0.33
async-compression-0.3.5
atty-0.2.14
autocfg-0.1.7
autocfg-1.0.1
backtrace-0.3.53
base64-0.12.3
bitfield-0.13.2
bitflags-1.2.1
block-buffer-0.7.3
block-buffer-0.9.0
block-cipher-0.8.0
block-modes-0.6.1
block-padding-0.1.5
block-padding-0.2.1
blowfish-0.6.0
buf_redux-0.8.4
bumpalo-3.4.0
byteorder-1.3.4
bytes-0.4.12
bytes-0.5.6
byte-tools-0.3.1
cast5-0.8.0
cc-1.0.61
cfb-mode-0.5.0
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
circular-0.3.0
clap-2.33.3
clear_on_drop-0.2.4
core-foundation-0.7.0
core-foundation-sys-0.7.0
cpuid-bool-0.1.2
crc24-0.1.6
crc32fast-1.2.0
crossbeam-channel-0.4.4
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-utils-0.7.2
curl-0.4.34
curl-sys-0.4.38+curl-7.73.0
curve25519-dalek-3.0.0
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
derive_builder-0.9.0
derive_builder_core-0.9.0
des-0.5.0
digest-0.8.1
digest-0.9.0
dtoa-0.4.6
ed25519-1.0.3
ed25519-dalek-1.0.1
effective-limits-0.5.2
either-1.6.1
encoding_rs-0.8.24
env_proxy-0.4.1
error-chain-0.12.4
fake-simd-0.1.2
filetime-0.2.12
flate2-1.0.18
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.3.6
futures-channel-0.3.6
futures-core-0.3.6
futures-executor-0.3.6
futures-io-0.3.6
futures-macro-0.3.6
futures-sink-0.3.6
futures-task-0.3.6
futures-util-0.3.6
generic-array-0.12.3
generic-array-0.14.4
getrandom-0.1.15
gimli-0.22.0
git-testament-0.1.9
git-testament-derive-0.1.10
h2-0.2.6
hashbrown-0.9.1
hermit-abi-0.1.17
hex-0.4.2
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
js-sys-0.3.45
keccak-0.1.0
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.79
libm-0.2.1
libz-sys-1.1.2
log-0.4.11
lzma-sys-0.1.17
maplit-1.0.2
matches-0.1.8
maybe-uninit-2.0.0
md-5-0.9.1
memchr-2.3.3
memoffset-0.5.6
mime-0.3.16
mime_guess-2.0.3
miniz_oxide-0.4.3
mio-0.6.22
miow-0.2.1
native-tls-0.2.4
net2-0.2.35
nom-4.2.3
num-bigint-0.2.6
num-bigint-dig-0.6.0
num_cpus-1.13.0
num-derive-0.3.2
num-integer-0.1.43
num-iter-0.1.41
num-traits-0.2.12
object-0.21.1
once_cell-1.4.1
opaque-debug-0.2.3
opaque-debug-0.3.0
opener-0.4.1
openssl-0.10.30
openssl-probe-0.1.2
openssl-src-111.12.0+1.1.1h
openssl-sys-0.9.58
pem-0.8.1
percent-encoding-2.1.0
pest-2.1.3
pest_derive-2.1.0
pest_generator-2.1.3
pest_meta-2.1.3
pgp-0.7.1
pin-project-0.4.27
pin-project-internal-0.4.27
pin-project-lite-0.1.10
pin-utils-0.1.0
pkg-config-0.3.19
ppv-lite86-0.2.9
proc-macro2-1.0.24
proc-macro-hack-0.5.18
proc-macro-nested-0.1.6
pulldown-cmark-0.8.0
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
rayon-1.4.1
rayon-core-1.8.1
redox_syscall-0.1.57
regex-1.4.1
regex-syntax-0.6.20
remove_dir_all-0.5.3
remove_dir_all-0.6.1
reqwest-0.10.8
retry-1.1.0
ripemd160-0.9.1
rsa-0.3.0
rs_tracing-1.0.1
rustc-demangle-0.1.17
ryu-1.0.5
safemem-0.3.3
same-file-1.0.6
schannel-0.1.19
scopeguard-1.1.0
security-framework-0.4.4
security-framework-sys-0.4.3
semver-0.11.0
semver-parser-0.10.0
serde-1.0.117
serde_derive-1.0.117
serde_json-1.0.59
serde_urlencoded-0.6.1
sha-1-0.8.2
sha-1-0.9.1
sha2-0.9.1
sha3-0.9.1
signature-1.2.2
simple_asn1-0.4.1
slab-0.4.2
smallvec-1.4.2
socket2-0.3.15
spin-0.5.2
stream-cipher-0.7.1
strsim-0.10.0
strsim-0.8.0
strsim-0.9.3
subtle-2.3.0
syn-1.0.45
synstructure-0.12.4
sys-info-0.6.1
tar-0.4.30
tempfile-3.1.0
term-0.5.1
textwrap-0.11.0
thiserror-1.0.21
thiserror-impl-1.0.21
thread_local-1.0.1
threadpool-1.8.1
time-0.1.44
tinyvec-0.3.4
tokio-0.2.22
tokio-socks-0.2.2
tokio-tls-0.3.1
tokio-util-0.3.1
toml-0.5.7
tower-service-0.3.0
tracing-0.1.21
tracing-core-0.1.17
try_from-0.3.2
try-lock-0.2.3
twofish-0.4.0
typenum-1.12.0
ucd-trie-0.1.3
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.13
unicode-width-0.1.8
unicode-xid-0.2.1
url-2.1.1
vcpkg-0.2.10
vec_map-0.8.2
version_check-0.1.5
version_check-0.9.2
wait-timeout-0.2.0
walkdir-2.3.1
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
x25519-dalek-1.1.0
xattr-0.2.2
xz2-0.1.6
zeroize-1.1.1
zeroize_derive-1.0.1
"

inherit bash-completion-r1 cargo prefix

DESCRIPTION="Rust toolchain installer"
HOMEPAGE="https://rust-lang.github.io/rustup/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rust-lang/${PN}.git"
else
	HOME_COMMIT="a243ee2fbee6022c57d56f5aa79aefe194eabe53"
	SRC_URI="https://github.com/rust-lang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/rbtcollins/home/archive/${HOME_COMMIT}.tar.gz -> home-${HOME_COMMIT}.tar.gz
		$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 MIT Unlicense ZLIB"
SLOT="0"
IUSE=""

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

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	# patch git dep to use pre-fetched tarball
	local home_path="home = { path = '"${WORKDIR}/home-${HOME_COMMIT}"' }"
	sed -i "s@^home =.*@${home_path}@" "${S}/Cargo.toml" || die

	default
}

src_configure() {
	local myfeatures=( no-self-update )
	cargo_src_configure
}

src_compile() {
	export OPENSSL_NO_VENDOR=true
	cargo_src_compile
}

src_install() {
	cargo_src_install
	einstalldocs
	newbin "$(prefixify_ro "${FILESDIR}"/symlink_rustup.sh)" rustup-init-gentoo

	ln -s "${ED}/usr/bin/rustup-init" rustup || die
	./rustup completions bash rustup > "${T}/rustup" || die
	./rustup completions zsh rustup > "${T}/_rustup" || die

	dobashcomp "${T}/rustup"

	insinto /usr/share/zsh/site-functions
	doins "${T}/_rustup"
}

pkg_postinst() {
		einfo "No rustup toolchains installed by default"
		einfo "eselect activated system rust toolchain can be added to rustup by running"
		einfo "helper script installed as ${EPREFIX}/usr/bin/rustup-init-gentoo"
		einfo "it will create symlinks to system-installed rustup in home directory"
		einfo "and rustup updates will be managed by portage"
		einfo "please delete current rustup binaries from ~/.cargo/bin/ (if any)"
		einfo "before running rustup-init-gentoo"
}
