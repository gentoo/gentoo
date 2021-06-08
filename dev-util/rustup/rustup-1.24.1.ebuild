# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.14.1
adler-0.2.3
aes-0.5.0
aesni-0.8.0
aes-soft-0.5.0
aho-corasick-0.7.15
ansi_term-0.11.0
anyhow-1.0.38
async-compression-0.3.7
atty-0.2.14
autocfg-0.1.7
autocfg-1.0.1
backtrace-0.3.56
base64-0.12.3
base64-0.13.0
bitfield-0.13.2
bitflags-1.2.1
block-buffer-0.9.0
block-cipher-0.8.0
block-modes-0.6.1
block-padding-0.2.1
blowfish-0.6.0
buf_redux-0.8.4
bumpalo-3.6.1
byteorder-1.4.2
bytes-1.0.1
cast5-0.8.0
cc-1.0.67
cfb-mode-0.5.0
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
circular-0.3.0
clap-2.33.3
clear_on_drop-0.2.4
const_fn-0.4.5
core-foundation-0.9.1
core-foundation-sys-0.8.2
cpuid-bool-0.1.2
crc24-0.1.6
crc32fast-1.2.1
crossbeam-channel-0.5.0
crossbeam-deque-0.8.0
crossbeam-epoch-0.9.1
crossbeam-utils-0.8.1
curl-0.4.34
curl-sys-0.4.40+curl-7.75.0
curve25519-dalek-3.0.2
darling-0.10.2
darling_core-0.10.2
darling_macro-0.10.2
derive_builder-0.9.0
derive_builder_core-0.9.0
des-0.5.0
digest-0.9.0
ed25519-1.0.3
ed25519-dalek-1.0.1
effective-limits-0.5.2
either-1.6.1
encoding_rs-0.8.28
env_proxy-0.4.1
error-chain-0.12.4
filetime-0.2.14
flate2-1.0.20
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.0.1
futures-channel-0.3.12
futures-core-0.3.12
futures-io-0.3.12
futures-macro-0.3.12
futures-sink-0.3.12
futures-task-0.3.12
futures-util-0.3.12
generic-array-0.14.4
getrandom-0.1.16
getrandom-0.2.2
gimli-0.23.0
git-testament-0.1.9
git-testament-derive-0.1.10
glob-0.3.0
h2-0.3.0
hashbrown-0.9.1
hermit-abi-0.1.18
hex-0.4.2
http-0.2.3
httparse-1.3.5
http-body-0.4.0
httpdate-0.3.2
hyper-0.14.4
hyper-rustls-0.22.1
hyper-tls-0.5.0
ident_case-1.0.1
idna-0.2.2
indexmap-1.6.1
ipnet-2.3.0
itertools-0.9.0
itoa-0.4.7
jobserver-0.1.21
js-sys-0.3.47
keccak-0.1.0
lazy_static-1.4.0
libc-0.2.86
libm-0.2.1
libz-sys-1.1.2
log-0.4.14
lzma-sys-0.1.17
matches-0.1.8
md-5-0.9.1
memchr-2.3.4
memoffset-0.6.1
mime-0.3.16
miniz_oxide-0.4.3
mio-0.7.8
miow-0.3.6
native-tls-0.2.7
nom-4.2.3
ntapi-0.3.6
num-bigint-0.2.6
num-bigint-dig-0.6.1
num_cpus-1.13.0
num-derive-0.3.3
num-integer-0.1.44
num-iter-0.1.42
num-traits-0.2.14
object-0.23.0
once_cell-1.5.2
opaque-debug-0.3.0
opener-0.4.1
openssl-0.10.32
openssl-probe-0.1.2
openssl-src-111.14.0+1.1.1j
openssl-sys-0.9.60
pem-0.8.3
percent-encoding-2.1.0
pest-2.1.3
pgp-0.7.1
pin-project-1.0.5
pin-project-internal-1.0.5
pin-project-lite-0.2.4
pin-utils-0.1.0
pkg-config-0.3.19
ppv-lite86-0.2.10
proc-macro2-1.0.24
proc-macro-hack-0.5.19
proc-macro-nested-0.1.7
pulldown-cmark-0.8.0
quote-1.0.9
rand-0.7.3
rand-0.8.3
rand_chacha-0.2.2
rand_chacha-0.3.0
rand_core-0.5.1
rand_core-0.6.2
rand_hc-0.2.0
rand_hc-0.3.0
rayon-1.5.0
rayon-core-1.9.0
redox_syscall-0.2.5
regex-1.4.3
regex-syntax-0.6.22
remove_dir_all-0.5.3
remove_dir_all-0.6.1
reqwest-0.11.1
retry-1.2.0
ring-0.16.20
ripemd160-0.9.1
rsa-0.3.0
rs_tracing-1.0.1
rustc-demangle-0.1.18
rustls-0.19.0
rustls-native-certs-0.5.0
ryu-1.0.5
safemem-0.3.3
same-file-1.0.6
schannel-0.1.19
scopeguard-1.1.0
sct-0.6.0
security-framework-2.0.0
security-framework-sys-2.0.0
semver-0.11.0
semver-parser-0.10.2
serde-1.0.123
serde_derive-1.0.123
serde_json-1.0.62
serde_urlencoded-0.7.0
sha-1-0.9.4
sha2-0.9.3
sha3-0.9.1
signature-1.3.0
simple_asn1-0.4.1
slab-0.4.2
smallvec-1.6.1
socket2-0.3.19
spin-0.5.2
stream-cipher-0.7.1
strsim-0.10.0
strsim-0.8.0
strsim-0.9.3
subtle-2.4.0
syn-1.0.60
synstructure-0.12.4
sys-info-0.6.1
tar-0.4.33
tempfile-3.2.0
term-0.5.1
textwrap-0.11.0
thiserror-1.0.24
thiserror-impl-1.0.24
thread_local-1.1.3
threadpool-1.8.1
time-0.1.43
tinyvec-1.1.1
tinyvec_macros-0.1.0
tokio-1.2.0
tokio-native-tls-0.3.0
tokio-rustls-0.22.0
tokio-socks-0.5.1
tokio-util-0.6.3
toml-0.5.8
tower-service-0.3.1
tracing-0.1.24
tracing-core-0.1.17
tracing-futures-0.2.5
try_from-0.3.2
try-lock-0.2.3
twofish-0.4.0
typenum-1.12.0
ucd-trie-0.1.3
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.17
unicode-width-0.1.8
unicode-xid-0.2.1
untrusted-0.7.1
url-2.2.1
vcpkg-0.2.11
vec_map-0.8.2
version_check-0.1.5
version_check-0.9.2
wait-timeout-0.2.0
walkdir-2.3.1
want-0.3.0
wasi-0.10.2+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.70
wasm-bindgen-backend-0.2.70
wasm-bindgen-futures-0.4.20
wasm-bindgen-macro-0.2.70
wasm-bindgen-macro-support-0.2.70
wasm-bindgen-shared-0.2.70
webpki-0.21.4
web-sys-0.3.47
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.7.0
winreg-0.8.0
x25519-dalek-1.1.0
xattr-0.2.2
xz2-0.1.6
zeroize-1.2.0
zeroize_derive-1.0.1
zstd-0.6.0+zstd.1.4.8
zstd-safe-3.0.0+zstd.1.4.8
zstd-sys-1.4.19+zstd.1.4.8
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
	# modeled after ci/run.bash upstream
	# reqwest-rustls-tls requires ring crate, which is not very portable.
	local myfeatures=(
		no-self-update
		curl-backend
		reqwest-backend
		reqwest-default-tls
	)
	case ${ARCH} in
		ppc*|mips*|riscv*|s390*)
			;;
		*) myfeatures+=( reqwest-rustls-tls )
			;;
	esac
	cargo_src_configure --no-default-features
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
