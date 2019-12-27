# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
aho-corasick-0.6.9
argon2rs-0.2.5
arrayvec-0.4.10
autocfg-0.1.2
backtrace-0.3.13
backtrace-sys-0.1.28
bitflags-1.0.4
bit-set-0.5.1
bit-vec-0.5.1
blake2-rfc-0.2.18
cc-1.0.29
cfg-if-0.1.6
chrono-0.4.6
clap-2.33.0
cloudabi-0.0.3
constant_time_eq-0.1.3
curl-sys-0.4.12
dirs-1.0.4
failure-0.1.5
failure_derive-0.1.5
fnv-1.0.6
fuchsia-cprng-0.1.1
gettext-rs-0.4.1
gettext-sys-0.19.8
idna-0.1.5
kernel32-sys-0.2.2
lazy_static-0.2.11
lazy_static-1.2.0
libc-0.2.48
libz-sys-1.0.18
locale_config-0.2.2
lock_api-0.1.5
matches-0.1.8
memchr-2.1.3
natord-1.0.9
nodrop-0.1.13
nom-4.2.3
num-integer-0.1.39
num-traits-0.2.6
once_cell-0.1.8
openssl-sys-0.9.53
parking_lot-0.7.1
parking_lot_core-0.4.0
percent-encoding-1.0.1
pkg-config-0.3.14
proc-macro2-0.4.27
proptest-0.7.2
quick-error-1.2.2
quote-0.6.11
rand-0.4.6
rand-0.5.6
rand-0.6.5
rand_chacha-0.1.1
rand_core-0.3.1
rand_core-0.4.0
rand_hc-0.1.0
rand_isaac-0.1.1
rand_jitter-0.1.3
rand_os-0.1.2
rand_pcg-0.1.1
rand_xorshift-0.1.1
rdrand-0.4.0
redox_syscall-0.1.51
redox_users-0.2.0
regex-0.2.11
regex-1.1.0
regex-syntax-0.4.2
regex-syntax-0.5.6
regex-syntax-0.6.5
remove_dir_all-0.5.1
rustc-demangle-0.1.13
rustc_version-0.2.3
rusty-fork-0.2.1
scoped_threadpool-0.1.9
scopeguard-0.3.3
section_testing-0.0.4
semver-0.9.0
semver-parser-0.7.0
smallvec-0.6.10
syn-0.15.26
synstructure-0.10.1
tempfile-3.0.6
textwrap-0.11.0
thread_local-0.3.6
time-0.1.42
ucd-util-0.1.3
unicode-bidi-0.3.4
unicode-normalization-0.1.8
unicode-segmentation-1.2.1
unicode-width-0.1.5
unicode-xid-0.1.0
url-1.7.2
utf8-ranges-1.0.2
vcpkg-0.2.6
version_check-0.1.5
wait-timeout-0.1.5
winapi-0.2.8
winapi-0.3.6
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
xdg-2.2.0
"

inherit toolchain-funcs cargo

DESCRIPTION="An RSS/Atom feed reader for text terminals"
HOMEPAGE="https://newsboat.org/ https://github.com/newsboat/newsboat"
SRC_URI="
	https://newsboat.org/releases/${PV}/${P}.tar.xz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="Apache-2.0 BSD-2 CC0-1.0 ISC MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="libressl"

RDEPEND="
	>=dev-db/sqlite-3.5:3
	>=dev-libs/stfl-0.21
	>=net-misc/curl-7.18.0
	>=dev-libs/json-c-0.11:=
	dev-libs/libxml2
	sys-libs/ncurses:0=[unicode]
"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig
	sys-devel/gettext
	sys-libs/zlib
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.11-flags.patch
	"${FILESDIR}"/${PN}-2.17.1-libressl.patch
)

src_configure() {
	./config.sh || die
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	emake prefix="/usr" CXX="$(tc-getCXX)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
}

src_test() {
	# tests require UTF-8 locale
	emake CXX="$(tc-getCXX)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" test
	# Tests fail if in ${S} rather than in ${S}/test
	cd "${S}"/test || die
	./test || die
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" docdir="/usr/share/doc/${PF}" install
	einstalldocs
}
