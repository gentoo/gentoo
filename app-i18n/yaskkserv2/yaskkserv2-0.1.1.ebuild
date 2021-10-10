# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CRATES="
adler32-1.0.4
aho-corasick-0.7.6
ansi_term-0.11.0
arrayvec-0.4.11
atty-0.2.13
autocfg-0.1.6
backtrace-0.3.37
backtrace-sys-0.1.31
base64-0.10.1
bincode-1.1.4
bitflags-1.1.0
boxfnonce-0.1.1
byteorder-1.3.2
bytes-0.4.12
c2-chacha-0.2.2
cc-1.0.45
cfg-if-0.1.9
clap-2.33.0
cloudabi-0.0.3
cookie-0.12.0
cookie_store-0.7.0
core-foundation-0.6.4
core-foundation-sys-0.6.2
crc32fast-1.2.0
crossbeam-deque-0.7.1
crossbeam-epoch-0.7.2
crossbeam-queue-0.1.2
crossbeam-utils-0.6.6
daemonize-0.4.1
dtoa-0.4.4
either-1.5.3
encoding_rs-0.8.20
env_logger-0.7.1
error-chain-0.11.0
error-chain-0.12.1
failure-0.1.5
failure_derive-0.1.5
flate2-1.0.11
fnv-1.0.6
foreign-types-0.3.2
foreign-types-shared-0.1.1
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.29
futures-cpupool-0.1.8
getrandom-0.1.12
h2-0.1.26
http-0.1.18
http-body-0.1.0
httparse-1.3.4
humantime-1.3.0
hyper-0.12.35
hyper-tls-0.3.2
idna-0.1.5
idna-0.2.0
indexmap-1.2.0
iovec-0.1.2
itoa-0.4.4
json-0.12.0
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.62
lock_api-0.1.5
log-0.4.11
matches-0.1.8
memchr-2.2.1
memoffset-0.5.1
mime-0.3.14
mime_guess-2.0.1
miniz_oxide-0.3.2
mio-0.6.19
miow-0.2.1
native-tls-0.2.3
net2-0.2.33
nodrop-0.1.13
num_cpus-1.10.1
once_cell-1.4.1
openssl-0.10.24
openssl-probe-0.1.2
openssl-sys-0.9.49
owning_ref-0.4.0
parking_lot-0.7.1
parking_lot_core-0.4.0
percent-encoding-1.0.1
percent-encoding-2.1.0
pkg-config-0.3.16
ppv-lite86-0.2.5
proc-macro2-0.4.30
proc-macro2-1.0.3
publicsuffix-1.5.3
quick-error-1.2.3
quote-0.6.13
quote-1.0.2
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
redox_syscall-0.1.56
regex-1.3.1
regex-syntax-0.6.12
remove_dir_all-0.5.2
reqwest-0.9.20
rustc-demangle-0.1.16
rustc-hash-1.0.1
rustc_version-0.2.3
ryu-1.0.0
schannel-0.1.16
scopeguard-0.3.3
scopeguard-1.0.0
security-framework-0.3.1
security-framework-sys-0.3.1
semver-0.9.0
semver-parser-0.7.0
serde-1.0.101
serde_derive-1.0.101
serde_json-1.0.40
serde_urlencoded-0.5.5
sha1-0.6.0
slab-0.4.2
smallvec-0.6.10
stable_deref_trait-1.1.1
string-0.2.1
strsim-0.8.0
syn-0.15.44
syn-1.0.11
synstructure-0.10.2
syslog-4.0.1
tempfile-3.1.0
termcolor-1.1.0
textwrap-0.11.0
thiserror-1.0.20
thiserror-impl-1.0.20
thread_local-0.3.6
time-0.1.42
tokio-0.1.22
tokio-buf-0.1.1
tokio-current-thread-0.1.6
tokio-executor-0.1.8
tokio-io-0.1.12
tokio-reactor-0.1.9
tokio-sync-0.1.6
tokio-tcp-0.1.3
tokio-threadpool-0.1.15
tokio-timer-0.2.11
try-lock-0.2.2
try_from-0.3.2
twoway-0.2.0
unchecked-index-0.2.2
unicase-2.5.1
unicode-bidi-0.3.4
unicode-normalization-0.1.8
unicode-width-0.1.6
unicode-xid-0.1.0
unicode-xid-0.2.0
url-1.7.2
url-2.1.0
uuid-0.7.4
vcpkg-0.2.7
vec_map-0.8.1
version_check-0.1.5
want-0.2.0
wasi-0.7.0
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.6.2
ws2_32-sys-0.2.1
"
TESTDATA="${PN}-testdata-202110"

inherit cargo systemd

DESCRIPTION="Yet Another SKK server"
HOMEPAGE="https://github.com/wachikun/yaskkserv2"
SRC_URI="https://github.com/wachikun/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	test? ( https://dev.gentoo.org/~hattya/distfiles/${TESTDATA}.tar.xz )"
RESTRICT="!test? ( test )"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="app-i18n/skk-jisyo
	dev-libs/openssl:0="
BDEPEND="test? (
	app-emacs/ddskk
	app-i18n/yaskkserv
)"

src_prepare() {
	default

	sed -i "/^dictionary =/s|= .*|= ${EPREFIX}/usr/lib/${PN}/default.euc|" etc/${PN}.conf
}

src_test() {
	export YASKKSERV2_TEST_DIRECTORY="${T}"/${PN}
	mkdir -p "${YASKKSERV2_TEST_DIRECTORY}" || die
	cp -r "${WORKDIR}"/${TESTDATA}/* "${YASKKSERV2_TEST_DIRECTORY}" || die
	cargo_src_test
}

src_install() {
	dosbin target/release/${PN}
	dobin  target/release/${PN}_make_dictionary
	einstalldocs

	keepdir /usr/lib/${PN}

	insinto /etc
	doins etc/${PN}.conf

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_preinst() {
	"${ED}"/usr/bin/${PN}_make_dictionary --dictionary-filename "${ED}"/usr/lib/${PN}/default.euc         "${EPREFIX}"/usr/share/skk/SKK-JISYO.L || die
	"${ED}"/usr/bin/${PN}_make_dictionary --dictionary-filename "${ED}"/usr/lib/${PN}/default.utf8 --utf8 "${EPREFIX}"/usr/share/skk/SKK-JISYO.L || die
}
