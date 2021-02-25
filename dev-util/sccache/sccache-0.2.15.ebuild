# Copyright 2017-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.14.1
adler-0.2.3
aho-corasick-0.7.15
ansi_term-0.11.0
anyhow-1.0.37
ar-0.8.0
arrayref-0.3.6
arrayvec-0.5.2
ascii-0.8.7
assert_cmd-1.0.2
async-channel-1.5.1
async-executor-1.4.0
async-global-executor-1.4.3
async-io-1.3.1
async-mutex-1.4.0
async-std-1.8.0
async-task-4.0.3
async-trait-0.1.42
atomic-waker-1.0.0
atty-0.2.14
autocfg-0.1.7
autocfg-1.0.1
backtrace-0.3.55
base64-0.10.1
base64-0.12.3
base64-0.13.0
base64-0.9.3
bincode-0.8.0
bincode-1.3.1
bitflags-1.2.1
blake2b_simd-0.5.11
blake3-0.3.7
block-buffer-0.9.0
blocking-1.0.2
boxfnonce-0.1.1
buf_redux-0.8.4
bufstream-0.1.4
bumpalo-3.4.0
byteorder-1.3.4
bytes-0.4.12
bytes-0.5.6
bytes-1.0.0
cache-padded-1.1.1
case-0.1.0
cc-1.0.66
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
chunked_transfer-0.3.1
clap-2.33.3
cloudabi-0.0.3
combine-4.5.2
concurrent-queue-1.2.2
conhash-0.4.0
constant_time_eq-0.1.5
cookie-0.12.0
cookie_store-0.7.0
core-foundation-0.9.1
core-foundation-sys-0.8.2
counted-array-0.1.2
cpuid-bool-0.1.2
crc32fast-1.2.1
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.1.2
crossbeam-queue-0.2.3
crossbeam-utils-0.6.6
crossbeam-utils-0.7.2
crossbeam-utils-0.8.1
crypto-mac-0.10.0
crypto-mac-0.8.0
daemonize-0.4.1
derive-error-0.0.3
difference-2.0.0
digest-0.9.0
directories-3.0.1
dirs-1.0.5
dirs-sys-0.3.5
doc-comment-0.3.3
dtoa-0.4.7
either-1.6.1
encoding_rs-0.8.26
env_logger-0.8.2
error-chain-0.12.4
event-listener-2.5.1
failure-0.1.8
failure_derive-0.1.8
fastrand-1.4.0
filetime-0.2.13
flate2-1.0.19
float-cmp-0.8.0
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.0.0
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.30
futures-0.3.9
futures-channel-0.3.9
futures-core-0.3.9
futures-cpupool-0.1.8
futures-executor-0.3.9
futures-io-0.3.9
futures-lite-1.11.3
futures-macro-0.3.9
futures-sink-0.3.9
futures-task-0.3.9
futures-util-0.3.9
generic-array-0.14.4
getopts-0.2.21
getrandom-0.1.16
gimli-0.23.0
glob-0.3.0
gloo-timers-0.2.1
h2-0.1.26
hashbrown-0.9.1
hermit-abi-0.1.17
hmac-0.10.1
http-0.1.21
httparse-1.3.4
http-body-0.1.0
humantime-2.0.1
hyper-0.12.35
hyper-tls-0.3.2
hyperx-0.12.0
idna-0.1.5
idna-0.2.0
indexmap-1.6.1
instant-0.1.9
iovec-0.1.4
itertools-0.10.0
itertools-0.9.0
itoa-0.4.7
jobserver-0.1.21
jsonwebtoken-7.2.0
js-sys-0.3.46
kernel32-sys-0.2.2
kv-log-macro-1.0.7
language-tags-0.2.2
lazy_static-1.4.0
libc-0.2.82
libmount-0.1.15
linked-hash-map-0.5.3
local-encoding-0.2.0
lock_api-0.3.4
log-0.3.9
log-0.4.11
matches-0.1.8
maybe-uninit-2.0.0
md5-0.3.8
md-5-0.9.1
memcached-rs-0.4.2
memchr-2.3.4
memoffset-0.5.6
mime-0.2.6
mime-0.3.16
mime_guess-1.8.8
mime_guess-2.0.3
miniz_oxide-0.4.3
mio-0.6.23
mio-named-pipes-0.1.7
mio-uds-0.6.8
miow-0.2.2
miow-0.3.6
multipart-0.15.4
native-tls-0.2.7
nb-connect-1.0.2
net2-0.2.37
nix-0.14.1
nix-0.19.1
normalize-line-endings-0.3.0
number_prefix-0.4.0
num-bigint-0.2.6
num_cpus-1.13.0
num-integer-0.1.44
num-traits-0.1.43
num-traits-0.2.14
object-0.22.0
once_cell-1.5.2
opaque-debug-0.3.0
openssl-0.10.32
openssl-probe-0.1.2
openssl-sys-0.9.60
parking-2.0.0
parking_lot-0.9.0
parking_lot_core-0.6.2
pem-0.8.2
percent-encoding-1.0.1
percent-encoding-2.1.0
phf-0.7.24
phf_codegen-0.7.24
phf_generator-0.7.24
phf_shared-0.7.24
pin-project-lite-0.1.11
pin-project-lite-0.2.1
pin-utils-0.1.0
pkg-config-0.3.19
polling-2.0.2
ppv-lite86-0.2.10
predicates-1.0.6
predicates-core-1.0.1
predicates-tree-1.0.1
proc-macro2-1.0.24
proc-macro-hack-0.5.19
proc-macro-nested-0.1.6
publicsuffix-1.5.4
pulldown-cmark-0.0.3
quick-error-1.2.3
quote-0.3.15
quote-1.0.8
rand-0.4.6
rand-0.5.6
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
redis-0.17.0
redox_syscall-0.1.57
redox_users-0.3.5
regex-1.4.2
regex-syntax-0.6.21
remove_dir_all-0.5.3
reqwest-0.9.24
retry-1.2.0
ring-0.16.19
rouille-3.0.0
rust-argon2-0.8.3
rustc-demangle-0.1.18
rustc_version-0.2.3
ryu-1.0.5
safemem-0.3.3
same-file-1.0.6
schannel-0.1.19
scopeguard-1.1.0
security-framework-2.0.0
security-framework-sys-2.0.0
selenium-rs-0.1.2
semver-0.9.0
semver-parser-0.7.0
serde-1.0.118
serde_derive-1.0.118
serde_json-1.0.61
serde_urlencoded-0.5.5
sha1-0.6.0
sha-1-0.9.2
sha2-0.9.2
signal-hook-registry-1.3.0
simple_asn1-0.4.1
siphasher-0.2.3
skeptic-0.4.0
slab-0.4.2
smallvec-0.6.13
socket2-0.3.19
spin-0.5.2
string-0.2.1
strip-ansi-escapes-0.1.0
strsim-0.8.0
subtle-2.4.0
syn-0.11.11
syn-1.0.58
synom-0.11.3
synstructure-0.12.4
syslog-5.0.0
tar-0.4.30
tempdir-0.3.7
tempfile-3.1.0
term-0.5.2
termcolor-1.1.2
textwrap-0.11.0
thiserror-1.0.23
thiserror-impl-1.0.23
thread_local-1.1.0
threadpool-1.8.1
time-0.1.44
tiny_http-0.6.2
tinyvec-1.1.0
tinyvec_macros-0.1.0
tokio-0.1.22
tokio-0.2.24
tokio-buf-0.1.1
tokio-codec-0.1.2
tokio-compat-0.1.6
tokio-current-thread-0.1.7
tokio-executor-0.1.10
tokio-fs-0.1.7
tokio-io-0.1.13
tokio-named-pipes-0.1.0
tokio-process-0.2.5
tokio-reactor-0.1.12
tokio-serde-0.1.0
tokio-serde-bincode-0.1.1
tokio-signal-0.2.9
tokio-sync-0.1.8
tokio-tcp-0.1.4
tokio-threadpool-0.1.18
tokio-timer-0.2.13
tokio-udp-0.1.6
tokio-uds-0.2.7
tokio-util-0.3.1
toml-0.5.8
tower-0.1.1
tower-buffer-0.1.2
tower-discover-0.1.0
tower-layer-0.1.0
tower-limit-0.1.3
tower-load-shed-0.1.0
tower-retry-0.1.0
tower-service-0.2.0
tower-timeout-0.1.1
tower-util-0.1.0
tracing-0.1.22
tracing-attributes-0.1.11
tracing-core-0.1.17
treeline-0.1.0
try_from-0.3.2
try-lock-0.2.3
twoway-0.1.8
typenum-1.12.0
unicase-1.4.2
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.16
unicode-width-0.1.8
unicode-xid-0.0.4
unicode-xid-0.2.1
unix_socket-0.5.0
untrusted-0.7.1
url-1.7.2
url-2.2.0
utf8parse-0.1.1
uuid-0.7.4
uuid-0.8.1
vcpkg-0.2.11
vec-arena-1.0.0
vec_map-0.8.2
version_check-0.1.5
version_check-0.9.2
version-compare-0.0.11
void-1.0.2
vte-0.3.3
wait-timeout-0.2.0
waker-fn-1.1.0
walkdir-2.3.1
want-0.2.0
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.69
wasm-bindgen-backend-0.2.69
wasm-bindgen-futures-0.4.19
wasm-bindgen-macro-0.2.69
wasm-bindgen-macro-support-0.2.69
wasm-bindgen-shared-0.2.69
web-sys-0.3.46
wepoll-sys-3.0.1
which-4.0.2
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.6.2
ws2_32-sys-0.2.1
xattr-0.2.2
zip-0.5.9
zstd-0.6.0+zstd.1.4.8
zstd-safe-3.0.0+zstd.1.4.8
zstd-sys-1.4.19+zstd.1.4.8
"

inherit cargo optfeature

DESCRIPTION="ccache/distcc like tool with support for rust and cloud storage"
HOMEPAGE="https://github.com/mozilla/sccache/"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mozilla/sccache.git"
else
	SRC_URI="https://github.com/mozilla/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 ISC MIT Unlicense ZLIB"
SLOT="0"
IUSE="azure dist-client dist-server gcs memcached redis s3"

BDEPEND="virtual/pkgconfig"

DEPEND="
	app-arch/zstd
	dist-server? ( dev-libs/openssl:0= )
	gcs? ( dev-libs/openssl:0= )
"

RDEPEND="${DEPEND}
	dist-server? ( sys-apps/bubblewrap )
"

QA_FLAGS_IGNORED="usr/bin/sccache*"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	myfeatures=(
		$(usev azure)
		$(usev dist-client)
		$(usev dist-server)
		$(usev gcs)
		$(usev memcached)
		$(usev redis)
		$(usev s3)
	)
	cargo_src_configure --no-default-features
}

src_install() {
	cargo_src_install

	keepdir /etc/sccache

	einstalldocs
	dodoc -r docs/.

	if use dist-server; then
		newinitd "${FILESDIR}"/server.initd sccache-server
		newconfd "${FILESDIR}"/server.confd sccache-server

		newinitd "${FILESDIR}"/scheduler.initd sccache-scheduler
		newconfd "${FILESDIR}"/scheduler.confd sccache-scheduler
	fi
}

src_test() {
	if [[ "${PV}" == *9999* ]]; then
		ewarn "tests are always broken for ${PV} (require network), skipping"
	else
		cargo_src_test
	fi
}

pkg_postinst() {
	ewarn "${PN} is experimental, please use with care"
	use memcached && optfeature "memcached backend support" net-misc/memcached
	use redis && optfeature "redis backend support" dev-db/redis
}
