# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# generated with cargo-ebuild 0.2.0
# needs itoa-0.3.4 for tests
# added bincode-1.2.0 manually
CRATES="
adler32-1.0.4
aho-corasick-0.7.6
ansi_term-0.11.0
ar-0.6.2
arc-swap-0.4.4
arrayref-0.3.5
arrayvec-0.5.1
ascii-0.8.7
ascii-0.9.3
assert_cmd-0.9.1
atty-0.2.13
autocfg-0.1.7
backtrace-0.3.40
backtrace-sys-0.1.32
base64-0.10.1
base64-0.11.0
base64-0.9.3
bincode-0.8.0
bincode-1.2.0
bincode-1.2.1
bitflags-1.2.1
blake2b_simd-0.5.9
block-buffer-0.7.3
block-padding-0.1.5
buf_redux-0.6.3
bufstream-0.1.4
byte-tools-0.3.1
byteorder-1.3.2
bytes-0.4.12
c2-chacha-0.2.3
case-0.1.0
cc-1.0.48
cfg-if-0.1.10
chrono-0.4.10
chunked_transfer-0.3.1
clap-2.33.0
cloudabi-0.0.3
combine-3.8.1
conhash-0.4.0
constant_time_eq-0.1.4
cookie-0.12.0
cookie_store-0.7.0
core-foundation-0.6.4
core-foundation-sys-0.6.2
counted-array-0.1.2
crc32fast-1.2.0
crossbeam-deque-0.7.2
crossbeam-epoch-0.8.0
crossbeam-queue-0.1.2
crossbeam-utils-0.5.0
crossbeam-utils-0.6.6
crossbeam-utils-0.7.0
crypto-mac-0.7.0
daemonize-0.3.0
derive-error-0.0.3
difference-2.0.0
digest-0.8.1
directories-1.0.2
dirs-1.0.5
dtoa-0.4.4
either-1.5.3
encoding_rs-0.8.20
env_logger-0.5.13
error-chain-0.11.0
error-chain-0.12.1
escargot-0.3.1
failure-0.1.6
failure_derive-0.1.6
fake-simd-0.1.2
filetime-0.1.15
filetime-0.2.8
flate2-1.0.13
float-cmp-0.4.0
fnv-1.0.6
foreign-types-0.3.2
foreign-types-shared-0.1.1
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.29
futures-cpupool-0.1.8
generic-array-0.12.3
getopts-0.2.21
getrandom-0.1.13
h2-0.1.26
hermit-abi-0.1.3
hmac-0.7.1
http-0.1.21
http-body-0.1.0
httparse-1.3.4
humantime-1.3.0
hyper-0.12.35
hyper-tls-0.3.2
hyperx-0.12.0
idna-0.1.5
idna-0.2.0
indexmap-1.3.0
iovec-0.1.4
itertools-0.7.11
itoa-0.3.4
itoa-0.4.4
jobserver-0.1.19
jsonwebtoken-6.0.1
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-1.4.0
libc-0.2.66
libmount-0.1.15
libz-sys-1.0.25
linked-hash-map-0.2.1
local-encoding-0.2.0
lock_api-0.3.2
log-0.3.9
log-0.4.8
lru-disk-cache-0.4.0
matches-0.1.8
maybe-uninit-2.0.0
md-5-0.8.0
md5-0.3.8
memcached-rs-0.3.0
memchr-1.0.2
memchr-2.2.1
memoffset-0.5.3
mime-0.2.6
mime-0.3.14
mime_guess-1.8.7
mime_guess-2.0.1
miniz_oxide-0.3.5
mio-0.6.21
mio-named-pipes-0.1.6
mio-uds-0.6.7
miow-0.2.1
miow-0.3.3
msdos_time-0.1.6
multipart-0.13.6
native-tls-0.2.3
net2-0.2.33
nix-0.11.1
nix-0.14.1
normalize-line-endings-0.2.2
num-integer-0.1.41
num-traits-0.1.43
num-traits-0.2.10
num_cpus-1.11.1
number_prefix-0.2.8
opaque-debug-0.2.3
openssl-0.10.26
openssl-probe-0.1.2
openssl-sys-0.9.53
parking_lot-0.9.0
parking_lot_core-0.6.2
percent-encoding-1.0.1
percent-encoding-2.1.0
phf-0.7.24
phf_codegen-0.7.24
phf_generator-0.7.24
phf_shared-0.7.24
pkg-config-0.3.17
podio-0.1.6
ppv-lite86-0.2.6
predicates-0.9.1
predicates-core-0.9.0
predicates-tree-0.9.0
proc-macro2-1.0.6
publicsuffix-1.5.4
pulldown-cmark-0.0.3
quick-error-1.2.2
quote-0.3.15
quote-1.0.2
rand-0.3.23
rand-0.4.6
rand-0.5.6
rand-0.6.5
rand-0.7.2
rand_chacha-0.1.1
rand_chacha-0.2.1
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
redis-0.9.1
redox_syscall-0.1.56
redox_users-0.3.1
regex-1.3.1
regex-syntax-0.6.12
remove_dir_all-0.5.2
reqwest-0.9.22
retry-0.4.0
ring-0.14.6
rouille-2.2.0
rust-argon2-0.5.1
rustc-demangle-0.1.16
rustc_version-0.2.3
ryu-1.0.2
safemem-0.2.0
safemem-0.3.3
same-file-0.1.3
sccache-0.2.13
schannel-0.1.16
scopeguard-1.0.0
security-framework-0.3.4
security-framework-sys-0.3.3
selenium-rs-0.1.1
semver-0.9.0
semver-parser-0.7.0
serde-1.0.103
serde_derive-1.0.103
serde_json-1.0.44
serde_urlencoded-0.5.5
sha-1-0.8.1
sha1-0.6.0
sha2-0.8.0
signal-hook-0.1.12
signal-hook-registry-1.2.0
siphasher-0.2.3
skeptic-0.4.0
slab-0.4.2
smallvec-0.6.13
smallvec-1.0.0
socket2-0.3.11
spin-0.5.2
string-0.2.1
strip-ansi-escapes-0.1.0
strsim-0.8.0
subtle-1.0.0
syn-0.11.11
syn-1.0.11
synom-0.11.3
synstructure-0.12.3
syslog-4.0.1
tar-0.4.26
tempdir-0.3.7
tempfile-3.1.0
term-0.5.2
termcolor-1.0.5
textwrap-0.11.0
thread_local-0.3.6
threadpool-1.7.1
time-0.1.42
tiny_http-0.6.2
tokio-0.1.22
tokio-buf-0.1.1
tokio-codec-0.1.1
tokio-current-thread-0.1.6
tokio-executor-0.1.9
tokio-fs-0.1.6
tokio-io-0.1.12
tokio-named-pipes-0.1.0
tokio-process-0.2.4
tokio-reactor-0.1.11
tokio-serde-0.1.0
tokio-serde-bincode-0.1.1
tokio-signal-0.2.7
tokio-sync-0.1.7
tokio-tcp-0.1.3
tokio-threadpool-0.1.17
tokio-timer-0.2.12
tokio-udp-0.1.5
tokio-uds-0.2.5
toml-0.4.10
tower-0.1.1
tower-buffer-0.1.2
tower-discover-0.1.0
tower-layer-0.1.0
tower-limit-0.1.1
tower-load-shed-0.1.0
tower-retry-0.1.0
tower-service-0.2.0
tower-timeout-0.1.1
tower-util-0.1.0
tracing-0.1.10
tracing-attributes-0.1.5
tracing-core-0.1.7
treeline-0.1.0
try-lock-0.2.2
try_from-0.3.2
twoway-0.1.8
typenum-1.11.2
unicase-1.4.2
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.11
unicode-width-0.1.7
unicode-xid-0.0.4
unicode-xid-0.2.0
unix_socket-0.5.0
unreachable-1.0.0
untrusted-0.6.2
url-1.7.2
url-2.1.0
utf8parse-0.1.1
uuid-0.7.4
vcpkg-0.2.8
vec_map-0.8.1
version-compare-0.0.10
version_check-0.1.5
version_check-0.9.1
void-1.0.2
vte-0.3.3
walkdir-1.0.7
want-0.2.0
wasi-0.7.0
which-2.0.1
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.2
winreg-0.6.2
ws2_32-sys-0.2.1
xattr-0.2.2
zip-0.4.2
"

inherit cargo optfeature

DESCRIPTION="ccache/distcc like tool with support for rust and cloud storage"
HOMEPAGE="https://github.com/mozilla/sccache/"
SRC_URI="https://github.com/mozilla/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Boost-1.0 ISC MIT Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="azure dist-client dist-server gcs memcached redis s3"

DEPEND="
	dist-server? ( dev-libs/openssl:0= )
	gcs? ( dev-libs/openssl:0= )
"

RDEPEND="${DEPEND}
	dist-server? ( sys-apps/bubblewrap )
"

QA_FLAGS_IGNORED="usr/bin/sccache*"

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
}

src_compile() {
	cargo_src_compile ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features
}

src_install() {
	cargo_src_install ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features

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
	cargo_src_test ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features
}

pkg_postinst() {
	ewarn "${PN} is experimental, please use with care"
	use memcached && optfeature "memcached backend support" net-misc/memcached
	use redis && optfeature "redis backend support" dev-db/redis
}
