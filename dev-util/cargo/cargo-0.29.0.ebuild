# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CARGO_SNAPSHOT_DATE="2016-09-01"

CRATES="
aho-corasick-0.6.6
ansi_term-0.11.0
atty-0.2.11
backtrace-0.3.9
backtrace-sys-0.1.23
bitflags-1.0.3
bufstream-0.1.3
cargo-0.29.0
cc-1.0.18
cfg-if-0.1.4
clap-2.32.0
cloudabi-0.0.3
cmake-0.1.31
commoncrypto-0.2.0
commoncrypto-sys-0.2.0
core-foundation-0.6.1
core-foundation-sys-0.6.1
crates-io-0.17.0
crossbeam-0.3.2
crypto-hash-0.3.1
curl-0.4.14
curl-sys-0.4.8
dtoa-0.4.3
env_logger-0.5.11
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
globset-0.4.1
hex-0.3.2
home-0.3.3
humantime-1.1.1
idna-0.1.5
ignore-0.4.3
itoa-0.4.2
jobserver-0.1.11
kernel32-sys-0.2.2
lazy_static-1.0.2
lazycell-0.6.0
libc-0.2.42
libgit2-sys-0.7.7
libssh2-sys-0.2.8
libz-sys-1.0.18
log-0.4.3
matches-0.1.7
memchr-2.0.1
miniz-sys-0.1.10
miow-0.3.1
num-traits-0.2.5
num_cpus-1.8.0
openssl-0.10.10
openssl-probe-0.1.2
openssl-sys-0.9.33
percent-encoding-1.0.1
pkg-config-0.3.12
proc-macro2-0.4.9
quick-error-1.2.2
quote-0.6.4
rand-0.4.2
rand-0.5.4
rand_core-0.2.1
redox_syscall-0.1.40
redox_termios-0.1.1
regex-1.0.2
regex-syntax-0.6.2
remove_dir_all-0.5.1
rustc-demangle-0.1.9
same-file-1.0.2
schannel-0.1.13
scopeguard-0.3.3
semver-0.9.0
semver-parser-0.7.0
serde-1.0.70
serde_derive-1.0.70
serde_ignored-0.0.4
serde_json-1.0.24
shell-escape-0.1.4
socket2-0.3.7
strsim-0.7.0
syn-0.14.6
synstructure-0.9.0
tar-0.4.16
tempfile-3.0.3
termcolor-0.3.6
termcolor-1.0.1
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.5
toml-0.4.6
ucd-util-0.1.1
unicode-bidi-0.3.4
unicode-normalization-0.1.7
unicode-width-0.1.5
unicode-xid-0.1.0
unreachable-1.0.0
url-1.7.1
utf8-ranges-1.0.0
vcpkg-0.2.4
vec_map-0.8.1
void-1.0.2
walkdir-2.1.4
winapi-0.2.8
winapi-0.3.5
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-0.1.6
wincolor-1.0.0
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
KEYWORDS="amd64 ~arm64 ~x86"

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
	net-libs/http-parser"
RDEPEND="${COMMON_DEPEND}
	!dev-util/cargo-bin
	net-misc/curl[ssl]"
DEPEND="${COMMON_DEPEND}
	>=virtual/rust-1.27.0
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
