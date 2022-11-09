# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

CRATES="
aho-corasick-0.7.18
atty-0.2.13
autocfg-1.1.0
backtrace-0.3.37
backtrace-sys-0.1.31
base64-0.13.0
bincode-1.3.3
bitflags-1.3.2
block-buffer-0.10.2
boxfnonce-0.1.1
bumpalo-3.10.0
bytes-1.1.0
c2-chacha-0.2.2
cc-1.0.45
cfg-if-0.1.9
cfg-if-1.0.0
clap-3.2.4
clap_lex-0.2.2
core-foundation-0.9.3
core-foundation-sys-0.8.3
cpufeatures-0.2.2
crypto-common-0.1.3
daemonize-0.4.1
digest-0.10.3
encoding_rs-0.8.20
env_logger-0.7.1
error-chain-0.11.0
fastrand-1.7.0
fnv-1.0.6
foreign-types-0.3.2
foreign-types-shared-0.1.1
form_urlencoded-1.1.0
futures-channel-0.3.21
futures-core-0.3.21
futures-io-0.3.21
futures-sink-0.3.21
futures-task-0.3.21
futures-util-0.3.21
generic-array-0.14.5
getrandom-0.1.12
h2-0.3.13
hashbrown-0.11.2
hermit-abi-0.1.19
http-0.2.8
http-body-0.4.5
httparse-1.7.1
httpdate-1.0.2
humantime-1.3.0
hyper-0.14.19
hyper-tls-0.5.0
idna-0.3.0
indexmap-1.8.2
instant-0.1.12
ipnet-2.5.0
itoa-0.4.4
itoa-1.0.2
js-sys-0.3.58
json-0.12.4
lazy_static-1.4.0
libc-0.2.126
log-0.4.11
matches-0.1.8
memchr-2.5.0
mime-0.3.16
mio-0.8.3
native-tls-0.2.10
num_cpus-1.13.1
once_cell-1.12.0
openssl-0.10.40
openssl-macros-0.1.0
openssl-probe-0.1.5
openssl-sys-0.9.74
os_str_bytes-6.1.0
percent-encoding-2.2.0
pin-project-lite-0.2.9
pin-utils-0.1.0
pkg-config-0.3.25
ppv-lite86-0.2.5
proc-macro2-1.0.39
quick-error-1.2.3
quote-1.0.2
rand-0.7.2
rand_chacha-0.2.1
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
redox_syscall-0.2.13
regex-1.5.6
regex-syntax-0.6.26
remove_dir_all-0.5.2
reqwest-0.11.11
rustc-demangle-0.1.16
rustc-hash-1.1.0
ryu-1.0.0
schannel-0.1.20
security-framework-2.6.1
security-framework-sys-2.6.1
serde-1.0.137
serde_derive-1.0.137
serde_json-1.0.40
serde_urlencoded-0.7.1
sha1-0.10.1
slab-0.4.2
socket2-0.4.4
strsim-0.10.0
syn-1.0.96
syslog-4.0.1
tempfile-3.3.0
termcolor-1.1.3
textwrap-0.15.0
thiserror-1.0.31
thiserror-impl-1.0.31
time-0.1.42
tinyvec-1.6.0
tinyvec_macros-0.1.0
tokio-1.19.2
tokio-native-tls-0.3.0
tokio-util-0.7.3
tower-service-0.3.1
tracing-0.1.35
tracing-core-0.1.27
try-lock-0.2.2
twoway-0.2.2
typenum-1.15.0
unchecked-index-0.2.2
unicode-bidi-0.3.4
unicode-ident-1.0.1
unicode-normalization-0.1.22
url-2.3.1
vcpkg-0.2.15
version_check-0.9.4
want-0.3.0
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.7.0
wasm-bindgen-0.2.81
wasm-bindgen-backend-0.2.81
wasm-bindgen-futures-0.4.31
wasm-bindgen-macro-0.2.81
wasm-bindgen-macro-support-0.2.81
wasm-bindgen-shared-0.2.81
web-sys-0.3.58
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows-sys-0.36.1
windows_aarch64_msvc-0.36.1
windows_i686_gnu-0.36.1
windows_i686_msvc-0.36.1
windows_x86_64_gnu-0.36.1
windows_x86_64_msvc-0.36.1
winreg-0.10.1
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
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="dev-libs/openssl:0="
RDEPEND="${DEPEND}
	app-i18n/skk-jisyo"
BDEPEND="test? (
	app-emacs/ddskk
	app-i18n/yaskkserv
)"

QA_FLAGS_IGNORED=".*"

src_prepare() {
	default

	sed -i "/^dictionary =/s|= .*|= ${EPREFIX}/usr/lib/${PN}/default.euc|" etc/${PN}.conf
	export OPENSSL_NO_VENDOR=true
	# skip network tests
	sed -i "s/^fn ${PN}.*_google_/#[ignore]\n&/" src/skk/test_unix/${PN}.rs
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
