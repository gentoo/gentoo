# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CARGO_SNAPSHOT_DATE="2016-09-01"

CRATES="
aho-corasick-0.6.8
ansi_term-0.11.0
arrayvec-0.4.7
atty-0.2.11
backtrace-0.3.9
backtrace-sys-0.1.24
bitflags-1.0.4
bufstream-0.1.3
cargo-0.30.0
cc-1.0.25
cfg-if-0.1.5
clap-2.32.0
cloudabi-0.0.3
commoncrypto-0.2.0
commoncrypto-sys-0.2.0
core-foundation-0.6.1
core-foundation-sys-0.6.1
crates-io-0.18.0
crossbeam-channel-0.2.6
crossbeam-epoch-0.6.0
crossbeam-utils-0.5.0
crypto-hash-0.3.1
curl-0.4.17
curl-sys-0.4.12
env_logger-0.5.13
failure-0.1.2
failure_derive-0.1.2
filetime-0.2.1
flate2-1.0.2
fnv-1.0.6
foreign-types-0.3.2
foreign-types-shared-0.1.1
fs2-0.4.3
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
git2-0.7.5
git2-curl-0.8.1
glob-0.2.11
globset-0.4.2
hex-0.3.2
home-0.3.3
humantime-1.1.1
idna-0.1.5
ignore-0.4.4
itoa-0.4.3
jobserver-0.1.11
kernel32-sys-0.2.2
lazy_static-1.1.0
lazycell-1.2.0
libc-0.2.43
libgit2-sys-0.7.8
libssh2-sys-0.2.11
libz-sys-1.0.22
lock_api-0.1.3
log-0.4.5
matches-0.1.8
memchr-2.1.0
memoffset-0.2.1
miniz-sys-0.1.10
miow-0.3.3
nodrop-0.1.12
num_cpus-1.8.0
openssl-0.10.12
openssl-probe-0.1.2
openssl-src-110.0.7+1.1.0i
openssl-sys-0.9.36
owning_ref-0.3.3
parking_lot-0.6.4
parking_lot_core-0.3.1
percent-encoding-1.0.1
pkg-config-0.3.14
proc-macro2-0.4.19
quick-error-1.2.2
quote-0.6.8
rand-0.4.3
rand-0.5.5
rand_core-0.2.1
redox_syscall-0.1.40
redox_termios-0.1.1
regex-1.0.5
regex-syntax-0.6.2
remove_dir_all-0.5.1
rustc-demangle-0.1.9
rustc-workspace-hack-1.0.0
rustc_version-0.2.3
rustfix-0.4.2
ryu-0.2.6
same-file-1.0.3
schannel-0.1.13
scopeguard-0.3.3
semver-0.9.0
semver-parser-0.7.0
serde-1.0.79
serde_derive-1.0.79
serde_ignored-0.0.4
serde_json-1.0.28
shell-escape-0.1.4
smallvec-0.6.5
socket2-0.3.8
stable_deref_trait-1.1.1
strsim-0.7.0
syn-0.14.9
syn-0.15.4
synstructure-0.9.0
tar-0.4.16
tempfile-3.0.4
termcolor-1.0.4
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
toml-0.4.6
ucd-util-0.1.1
unicode-bidi-0.3.4
unicode-normalization-0.1.7
unicode-width-0.1.5
unicode-xid-0.1.0
unreachable-1.0.0
url-1.7.1
utf8-ranges-1.0.1
vcpkg-0.2.6
vec_map-0.8.1
version_check-0.1.4
void-1.0.2
walkdir-2.2.5
winapi-0.2.8
winapi-0.3.5
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.1
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-1.0.1
"

inherit cargo bash-completion-r1 multiprocessing versionator

BOOTSTRAP_VERSION="0.$(($(get_version_component_range 2) - 1)).0"

DESCRIPTION="The Rust's package manager"
HOMEPAGE="http://crates.io"
SRC_URI="https://github.com/rust-lang/cargo/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	x86?   (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-i686-unknown-linux-gnu.tar.xz
	)
	amd64? (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-x86_64-unknown-linux-gnu.tar.xz
	)
	arm? (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-arm-unknown-linux-gnueabi.tar.xz
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-arm-unknown-linux-gnueabihf.tar.xz
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-armv7-unknown-linux-gnueabihf.tar.xz
	)
	arm64? (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-aarch64-unknown-linux-gnu.tar.xz
	)"

RESTRICT="mirror"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

IUSE="doc libressl"

if [[ ${ARCH} = "amd64" ]]; then
	TRIPLE="x86_64-unknown-linux-gnu"
elif [[ ${ARCH} = "x86" ]]; then
	TRIPLE="i686-unknown-linux-gnu"
elif [[ ${ARCH} = "arm64" ]]; then
	TRIPLE="aarch64-unknown-linux-gnu"
elif [[ "$(tc-is-softfloat)" != "no" ]] && [[ ${CHOST} == armv6* ]]; then
	TRIPLE="arm-unknown-linux-gnueabi"
elif [[ ${CHOST} == armv6*h* ]]; then
	TRIPLE="arm-unknown-linux-gnueabihf"
elif [[ ${CHOST} == armv7*h* ]]; then
	TRIPLE="armv7-unknown-linux-gnueabihf"
fi

COMMON_DEPEND="sys-libs/zlib
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-libs/libssh2
	net-libs/http-parser:="
RDEPEND="${COMMON_DEPEND}
	!dev-util/cargo-bin
	net-misc/curl[ssl]"
DEPEND="${COMMON_DEPEND}
	>=virtual/rust-1.28.0
	dev-util/cmake
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/findutils
	sys-apps/sed"

PATCHES=()

src_configure() {
	# Do nothing
	echo "Configuring cargo..."
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	local cargo="${WORKDIR}/cargo-${BOOTSTRAP_VERSION}-${TRIPLE}/cargo/bin/cargo"
	${cargo} build -j$(makeopts_jobs) --release || die

	# Building HTML documentation
	use doc && ${cargo} doc
}

src_install() {
	dobin target/release/cargo

	# Install HTML documentation
	use doc && HTML_DOCS=("target/doc")
	einstalldocs

	newbashcomp src/etc/cargo.bashcomp.sh cargo
	insinto /usr/share/zsh/site-functions
	doins src/etc/_cargo
	doman src/etc/man/*
}
