# Copyright 2017-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# needs itoa-0.3.4 for tests
CRATES="
adler32-1.0.3
aho-corasick-0.6.9
ansi_term-0.11.0
ar-0.6.1
arc-swap-0.3.6
arraydeque-0.4.3
arrayvec-0.4.7
ascii-0.8.7
ascii-0.9.1
assert_cmd-0.9.1
atty-0.2.11
backtrace-0.3.9
backtrace-sys-0.1.24
base64-0.9.3
bincode-0.8.0
bincode-1.0.1
bitflags-0.9.1
bitflags-1.0.4
buf_redux-0.6.3
bufstream-0.1.4
build_const-0.2.1
byteorder-1.2.7
bytes-0.4.11
case-0.1.0
cc-1.0.25
cfg-if-0.1.6
chrono-0.4.6
chunked_transfer-0.3.1
clap-2.32.0
cloudabi-0.0.3
combine-3.6.3
conhash-0.4.0
core-foundation-0.2.3
core-foundation-0.5.1
core-foundation-sys-0.2.3
core-foundation-sys-0.5.1
counted-array-0.1.2
crc-1.8.1
crossbeam-deque-0.6.2
crossbeam-epoch-0.6.1
crossbeam-utils-0.5.0
crossbeam-utils-0.6.1
daemonize-0.3.0
derive-error-0.0.3
difference-2.0.0
directories-1.0.2
dtoa-0.4.3
either-1.5.0
encoding_rs-0.8.10
env_logger-0.5.13
error-chain-0.12.0
escargot-0.3.1
failure-0.1.3
failure_derive-0.1.3
filetime-0.1.15
filetime-0.2.4
flate2-1.0.5
flate2-crc-0.1.1
float-cmp-0.4.0
fnv-1.0.6
foreign-types-0.3.2
foreign-types-shared-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.25
futures-cpupool-0.1.8
gcc-0.3.55
getopts-0.2.18
h2-0.1.13
http-0.1.14
httparse-1.3.3
humantime-1.1.1
hyper-0.11.27
hyper-0.12.16
hyper-tls-0.1.4
hyper-tls-0.3.1
hyperx-0.12.0
idna-0.1.5
indexmap-1.0.2
iovec-0.1.2
itertools-0.7.9
itoa-0.3.4
itoa-0.4.3
jobserver-0.1.11
jsonwebtoken-5.0.1
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-0.2.11
lazy_static-1.2.0
lazycell-1.2.0
libc-0.2.44
libflate-0.1.18
libmount-0.1.11
linked-hash-map-0.2.1
local-encoding-0.2.0
lock_api-0.1.5
log-0.3.9
log-0.4.6
lru-disk-cache-0.2.0
matches-0.1.8
md5-0.3.8
memcached-rs-0.3.0
memchr-1.0.2
memchr-2.1.1
memoffset-0.2.1
mime-0.2.6
mime-0.3.12
mime_guess-1.8.6
mime_guess-2.0.0-alpha.6
miniz_oxide-0.2.0
miniz_oxide_c_api-0.2.0
mio-0.6.16
mio-named-pipes-0.1.6
mio-uds-0.6.7
miow-0.2.1
miow-0.3.3
msdos_time-0.1.6
multipart-0.13.6
native-tls-0.1.5
native-tls-0.2.2
net2-0.2.33
nix-0.11.0
nodrop-0.1.13
normalize-line-endings-0.2.2
num-integer-0.1.39
num-traits-0.1.43
num-traits-0.2.6
num_cpus-1.8.0
number_prefix-0.2.8
openssl-0.10.15
openssl-0.9.24
openssl-probe-0.1.2
openssl-sys-0.9.39
owning_ref-0.4.0
parking_lot-0.6.4
parking_lot_core-0.3.1
percent-encoding-1.0.1
phf-0.7.23
phf_codegen-0.7.23
phf_generator-0.7.23
phf_shared-0.7.23
pkg-config-0.3.14
podio-0.1.6
predicates-0.9.1
predicates-core-0.9.0
predicates-tree-0.9.0
proc-macro2-0.4.24
pulldown-cmark-0.0.3
quick-error-1.2.2
quote-0.3.15
quote-0.6.10
rand-0.3.22
rand-0.4.3
rand-0.5.5
rand-0.6.1
rand_chacha-0.1.0
rand_core-0.2.2
rand_core-0.3.0
rand_hc-0.1.0
rand_isaac-0.1.0
rand_pcg-0.1.1
rand_xorshift-0.1.0
redis-0.9.1
redox_syscall-0.1.42
redox_termios-0.1.1
regex-1.0.6
regex-syntax-0.6.3
relay-0.1.1
remove_dir_all-0.5.1
reqwest-0.8.8
reqwest-0.9.5
retry-0.4.0
ring-0.13.2
rouille-2.2.0
rust-crypto-0.2.36
rustc-demangle-0.1.9
rustc-serialize-0.3.24
rustc_version-0.2.3
ryu-0.2.7
safemem-0.2.0
safemem-0.3.0
same-file-0.1.3
schannel-0.1.14
scoped-tls-0.1.2
scopeguard-0.3.3
security-framework-0.1.16
security-framework-0.2.1
security-framework-sys-0.1.16
security-framework-sys-0.2.1
selenium-rs-0.1.1
semver-0.9.0
semver-parser-0.7.0
serde-1.0.80
serde_derive-1.0.80
serde_json-1.0.33
serde_urlencoded-0.5.4
sha1-0.6.0
signal-hook-0.1.6
siphasher-0.2.3
skeptic-0.4.0
slab-0.4.1
smallvec-0.6.6
socket2-0.3.8
stable_deref_trait-1.1.1
string-0.1.2
strip-ansi-escapes-0.1.0
strsim-0.7.0
syn-0.11.11
syn-0.15.21
synom-0.11.3
synstructure-0.10.1
tar-0.4.20
tempdir-0.3.7
tempfile-3.0.4
term-0.5.1
termcolor-1.0.4
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
threadpool-1.7.1
time-0.1.40
tiny_http-0.6.2
tokio-0.1.13
tokio-codec-0.1.1
tokio-core-0.1.17
tokio-current-thread-0.1.4
tokio-executor-0.1.5
tokio-fs-0.1.4
tokio-io-0.1.10
tokio-named-pipes-0.1.0
tokio-process-0.2.3
tokio-reactor-0.1.7
tokio-serde-0.1.0
tokio-serde-bincode-0.1.1
tokio-service-0.1.0
tokio-signal-0.2.7
tokio-tcp-0.1.2
tokio-threadpool-0.1.9
tokio-timer-0.2.8
tokio-tls-0.1.4
tokio-udp-0.1.3
tokio-uds-0.2.4
toml-0.4.9
treeline-0.1.0
try-lock-0.1.0
try-lock-0.2.2
twoway-0.1.8
ucd-util-0.1.3
unicase-1.4.2
unicase-2.2.0
unicode-bidi-0.3.4
unicode-normalization-0.1.7
unicode-width-0.1.5
unicode-xid-0.0.4
unicode-xid-0.1.0
unix_socket-0.5.0
unreachable-1.0.0
untrusted-0.6.2
url-1.7.2
utf8-ranges-1.0.2
utf8parse-0.1.1
uuid-0.6.5
uuid-0.7.1
vcpkg-0.2.6
vec_map-0.8.1
version_check-0.1.5
void-1.0.2
vte-0.3.3
walkdir-1.0.7
want-0.0.4
want-0.0.6
winapi-0.2.8
winapi-0.3.6
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.1
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
ws2_32-sys-0.2.1
which-2.0.0
xattr-0.2.2
zip-0.4.2
"

inherit cargo eutils

DESCRIPTION="ccache/distcc like tool with support for rust and cloud storage"
HOMEPAGE="https://github.com/mozilla/sccache/"
SRC_URI="https://github.com/mozilla/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="azure dist-client dist-server gcs memcached redis s3"

DEPEND="
	dist-server? ( dev-libs/openssl:0= )
	gcs? ( dev-libs/openssl:0= )
"

RDEPEND="${DEPEND}
	dist-client? ( sys-devel/icecream )
	dist-server? ( sys-apps/bubblewrap )
"

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

src_compile(){
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

		insinto /etc/logrotate.d
		newins "${FILESDIR}/logrotated" sccache
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
