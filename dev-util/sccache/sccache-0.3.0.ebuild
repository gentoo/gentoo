# Copyright 2017-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# don't forget to add itoa-0.3.4 for tests https://bugs.gentoo.org/803512
CRATES="
adler-1.0.2
aho-corasick-0.7.18
ansi_term-0.12.1
anyhow-1.0.53
ar-0.9.0
arrayref-0.3.6
arrayvec-0.5.2
ascii-1.0.0
assert_cmd-2.0.4
async-channel-1.6.1
async-trait-0.1.52
atty-0.2.14
autocfg-1.1.0
base64-0.12.3
base64-0.13.0
bincode-1.3.3
bitflags-1.3.2
blake3-0.3.8
block-buffer-0.10.2
boxfnonce-0.1.1
bstr-0.2.17
buf_redux-0.8.4
bufstream-0.1.4
bumpalo-3.9.1
byteorder-1.4.3
bytes-1.1.0
cache-padded-1.2.0
cc-1.0.72
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
chunked_transfer-1.4.0
clap-2.34.0
combine-4.6.3
concurrent-queue-1.2.2
config-0.10.1
conhash-0.4.0
constant_time_eq-0.1.5
core-foundation-0.9.3
core-foundation-sys-0.8.3
counted-array-0.1.2
cpufeatures-0.2.1
crc32fast-1.3.2
crossbeam-queue-0.3.4
crossbeam-utils-0.8.7
crypto-common-0.1.2
crypto-mac-0.8.0
daemonize-0.4.1
deadpool-0.7.0
difflib-0.4.0
digest-0.9.0
digest-0.10.2
directories-4.0.1
dirs-sys-0.3.6
displaydoc-0.1.7
doc-comment-0.3.3
dtoa-0.4.8
either-1.6.1
encoding_rs-0.8.30
env_logger-0.9.0
error-chain-0.12.4
event-listener-2.5.2
fastrand-1.7.0
filetime-0.2.15
flate2-1.0.22
float-cmp-0.9.0
fnv-1.0.7
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.0.1
fuchsia-cprng-0.1.1
futures-0.3.21
futures-channel-0.3.21
futures-core-0.3.21
futures-executor-0.3.21
futures-io-0.3.21
futures-lite-1.12.0
futures-locks-0.7.0
futures-macro-0.3.21
futures-sink-0.3.21
futures-task-0.3.21
futures-timer-3.0.2
futures-util-0.3.21
generic-array-0.14.5
getopts-0.2.21
getrandom-0.1.16
getrandom-0.2.4
h2-0.3.11
hashbrown-0.11.2
hermit-abi-0.1.19
hmac-0.12.0
http-0.2.6
http-body-0.4.4
http-types-2.12.0
httparse-1.6.0
httpdate-1.0.2
humantime-2.1.0
hyper-0.14.17
hyper-tls-0.5.0
hyperx-1.4.0
idna-0.2.3
indexmap-1.8.0
infer-0.2.3
instant-0.1.12
ipnet-2.3.1
itertools-0.10.3
itoa-0.4.8
itoa-1.0.1
jobserver-0.1.24
js-sys-0.3.56
jsonwebtoken-7.2.0
kernel32-sys-0.2.2
language-tags-0.3.2
lazy_static-1.4.0
lexical-core-0.7.6
libc-0.2.117
libmount-0.1.15
linked-hash-map-0.5.4
local-encoding-0.2.0
lock_api-0.4.6
log-0.4.14
matches-0.1.9
md-5-0.10.0
md5-0.3.8
memcached-rs-0.4.2
memchr-2.4.1
memoffset-0.6.5
mime-0.3.16
mime_guess-2.0.3
miniz_oxide-0.4.4
mio-0.7.14
miow-0.3.7
multipart-0.18.0
native-tls-0.2.8
nix-0.14.1
nix-0.23.1
nom-5.1.2
normalize-line-endings-0.3.0
ntapi-0.3.7
num-bigint-0.2.6
num-integer-0.1.44
num-traits-0.2.14
num_cpus-1.13.1
number_prefix-0.4.0
once_cell-1.9.0
openssl-0.10.38
openssl-probe-0.1.5
openssl-sys-0.9.72
parity-tokio-ipc-0.9.0
parking-2.0.0
parking_lot-0.11.2
parking_lot_core-0.8.5
pem-0.8.3
percent-encoding-2.1.0
pin-project-1.0.10
pin-project-internal-1.0.10
pin-project-lite-0.2.8
pin-utils-0.1.0
pkg-config-0.3.24
ppv-lite86-0.2.16
predicates-2.1.1
predicates-core-1.0.3
predicates-tree-1.0.5
proc-macro2-1.0.36
pulldown-cmark-0.0.3
quick-error-1.2.3
quote-1.0.15
rand-0.4.6
rand-0.7.3
rand-0.8.4
rand_chacha-0.2.2
rand_chacha-0.3.1
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_core-0.6.3
rand_hc-0.2.0
rand_hc-0.3.1
rdrand-0.4.0
redis-0.21.5
redox_syscall-0.2.10
redox_users-0.4.0
regex-1.5.4
regex-automata-0.1.10
regex-syntax-0.6.25
remove_dir_all-0.5.3
reqwest-0.11.9
retry-1.3.1
ring-0.16.20
rouille-3.4.0
ryu-1.0.9
safemem-0.3.3
same-file-1.0.6
schannel-0.1.19
scopeguard-1.1.0
security-framework-2.6.1
security-framework-sys-2.6.1
semver-0.9.0
semver-parser-0.7.0
serde-1.0.136
serde_derive-1.0.136
serde_json-1.0.79
serde_qs-0.8.5
serde_repr-0.1.7
serde_urlencoded-0.7.1
serial_test-0.5.1
serial_test_derive-0.5.1
sha-1-0.10.0
sha1-0.6.1
sha1_smol-1.0.0
sha2-0.10.1
signal-hook-registry-1.4.0
simple_asn1-0.4.1
skeptic-0.4.0
slab-0.4.5
smallvec-1.8.0
socket2-0.4.4
spin-0.5.2
static_assertions-1.1.0
stringmatch-0.3.3
strip-ansi-escapes-0.1.1
strsim-0.8.0
subtle-2.4.1
syn-1.0.86
syslog-5.0.0
tar-0.4.38
tempdir-0.3.7
tempfile-3.3.0
termcolor-1.1.2
termtree-0.2.4
textwrap-0.11.0
thirtyfour-0.27.3
thirtyfour_sync-0.27.1
thiserror-1.0.30
thiserror-impl-1.0.30
threadpool-1.8.1
time-0.1.43
time-0.3.2
tiny_http-0.8.2
tinyvec-1.5.1
tinyvec_macros-0.1.0
tokio-1.16.1
tokio-macros-1.7.0
tokio-native-tls-0.3.0
tokio-serde-0.8.0
tokio-util-0.6.9
toml-0.5.8
tower-0.4.11
tower-layer-0.3.1
tower-service-0.3.1
tracing-0.1.30
tracing-attributes-0.1.19
tracing-core-0.1.22
try-lock-0.2.3
twoway-0.1.8
typenum-1.15.0
unicase-2.6.0
unicode-bidi-0.3.7
unicode-normalization-0.1.19
unicode-width-0.1.9
unicode-xid-0.2.2
unix_socket-0.5.0
untrusted-0.7.1
url-2.2.2
urlparse-0.7.3
utf8parse-0.2.0
uuid-0.8.2
vcpkg-0.2.15
vec_map-0.8.2
version-compare-0.1.0
version_check-0.9.4
void-1.0.2
vte-0.10.1
vte_generate_state_changes-0.1.1
wait-timeout-0.2.0
waker-fn-1.1.0
walkdir-2.3.2
want-0.3.0
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.2+wasi-snapshot-preview1
wasm-bindgen-0.2.79
wasm-bindgen-backend-0.2.79
wasm-bindgen-futures-0.4.29
wasm-bindgen-macro-0.2.79
wasm-bindgen-macro-support-0.2.79
wasm-bindgen-shared-0.2.79
web-sys-0.3.56
which-4.2.4
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.7.0
wiremock-0.4.9
xattr-0.2.2
zip-0.5.13
zstd-0.6.1+zstd.1.4.9
zstd-safe-3.0.1+zstd.1.4.9
zstd-sys-1.4.20+zstd.1.4.9
"

inherit cargo optfeature systemd

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
IUSE="azure dist-client dist-server gcs memcached redis s3 simple-s3"
REQUIRED_USE="s3? ( simple-s3 )"

BDEPEND="virtual/pkgconfig"

DEPEND="
	sys-libs/zlib:=
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
		native-zlib
		$(usev azure)
		$(usev dist-client)
		$(usev dist-server)
		$(usev gcs)
		$(usev memcached)
		$(usev redis)
		$(usev s3)
		$(usev simple-s3)
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

		systemd_dounit "${FILESDIR}"/sccache-server.service
		systemd_dounit "${FILESDIR}"/sccache-scheduler.service

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
