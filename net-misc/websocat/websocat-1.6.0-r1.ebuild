# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
anymap-0.12.1
autocfg-0.1.7
autocfg-1.0.1
base64-0.10.1
base64-0.9.3
bitflags-1.2.1
block-buffer-0.7.3
block-padding-0.1.5
byte-tools-0.3.1
byteorder-1.3.4
bytes-0.4.12
cc-1.0.66
cfg-if-0.1.10
cfg-if-1.0.0
clap-2.33.3
cloudabi-0.0.3
core-foundation-0.9.1
core-foundation-sys-0.8.2
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.1.2
crossbeam-queue-0.2.3
crossbeam-utils-0.6.6
crossbeam-utils-0.7.2
derivative-1.0.4
digest-0.8.1
env_logger-0.6.2
fake-simd-0.1.2
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.30
generic-array-0.12.3
getrandom-0.1.15
heck-0.3.1
hermit-abi-0.1.17
http-0.1.21
http-bytes-0.1.0
httparse-1.3.4
hyper-0.10.16
idna-0.1.5
iovec-0.1.4
itoa-0.4.6
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-1.4.0
libc-0.2.81
lock_api-0.3.4
log-0.3.9
log-0.4.11
matches-0.1.8
maybe-uninit-2.0.0
memoffset-0.5.6
mime-0.2.6
mio-0.6.23
mio-named-pipes-0.1.7
mio-uds-0.6.8
miow-0.2.2
miow-0.3.6
native-tls-0.2.6
net2-0.2.37
num_cpus-1.13.0
opaque-debug-0.2.3
openssl-0.10.31
openssl-probe-0.1.2
openssl-sys-0.9.59
parking_lot-0.9.0
parking_lot_core-0.6.2
percent-encoding-1.0.1
pkg-config-0.3.19
ppv-lite86-0.2.10
proc-macro2-0.4.30
quote-0.6.13
rand-0.6.5
rand-0.7.3
rand_chacha-0.1.1
rand_chacha-0.2.2
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_hc-0.1.0
rand_hc-0.2.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rdrand-0.4.0
readwrite-0.1.2
redox_syscall-0.1.57
remove_dir_all-0.5.3
rustc_version-0.2.3
safemem-0.3.3
schannel-0.1.19
scopeguard-1.1.0
security-framework-2.0.0
security-framework-sys-2.0.0
semver-0.9.0
semver-parser-0.7.0
sha-1-0.8.2
signal-hook-registry-1.2.2
slab-0.4.2
slab_typesafe-0.1.3
smallvec-0.6.13
smart-default-0.3.0
socket2-0.3.18
structopt-0.2.16
structopt-derive-0.2.16
syn-0.15.44
tempfile-3.1.0
textwrap-0.11.0
time-0.1.44
tinyvec-1.1.0
tinyvec_macros-0.1.0
tk-listen-0.2.1
tokio-0.1.22
tokio-codec-0.1.2
tokio-current-thread-0.1.7
tokio-executor-0.1.10
tokio-file-unix-0.5.1
tokio-fs-0.1.7
tokio-io-0.1.13
tokio-process-0.2.5
tokio-reactor-0.1.12
tokio-signal-0.2.9
tokio-stdin-stdout-0.1.5
tokio-sync-0.1.8
tokio-tcp-0.1.4
tokio-threadpool-0.1.18
tokio-timer-0.2.13
tokio-tls-0.2.1
tokio-udp-0.1.6
tokio-uds-0.2.7
traitobject-0.1.0
typeable-0.1.2
typenum-1.12.0
unicase-1.4.2
unicode-bidi-0.3.4
unicode-normalization-0.1.16
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.1.0
url-1.7.2
vcpkg-0.2.11
version_check-0.1.5
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
websocat-1.6.0
websocket-0.26.2
websocket-base-0.26.2
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
"

inherit cargo

DESCRIPTION="Command-line client for WebSockets, like netcat, with socat-like functions"
HOMEPAGE="https://github.com/vi/websocat"
SRC_URI="$(cargo_crate_uris ${CRATES})
	https://dev.gentoo.org/~zmedico/dist/websocat-1.6.0-libressl-3.3.patch.xz"
LICENSE="MIT Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 ISC Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl ssl"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
DEPEND="
	${RUST_DEPEND}
	${RDEPEND}
"
QA_FLAGS_IGNORED="/usr/bin/websocat"

src_prepare() {
	default
	local patch=${WORKDIR}/websocat-1.6.0-libressl-3.3.patch
	patch "${WORKDIR}/cargo_home/gentoo/websocat-1.6.0/Cargo.lock" < "${patch}" || die
	patch "${S}/Cargo.lock" < "${patch}" || die
}

src_configure() {
	local myfeatures=(
		$(usex ssl ssl '')
		seqpacket
		signal_handler
		tokio-process
		unix_stdio
	)
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install
	dodoc *.md
}
