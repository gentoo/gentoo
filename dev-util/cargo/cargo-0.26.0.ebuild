# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CARGO_SNAPSHOT_DATE="2016-09-01"
CRATES="
aho-corasick-0.5.3
aho-corasick-0.6.4
atty-0.2.8
backtrace-0.3.5
backtrace-sys-0.1.16
bitflags-0.9.1
bitflags-1.0.1
bufstream-0.1.3
cc-1.0.9
cfg-if-0.1.2
cmake-0.1.30
commoncrypto-0.2.0
commoncrypto-sys-0.2.0
core-foundation-0.5.1
core-foundation-sys-0.5.1
crates-io-0.15.0
crossbeam-0.3.2
crypto-hash-0.3.1
curl-0.4.11
curl-sys-0.4.1
docopt-0.8.3
dtoa-0.4.2
env_logger-0.5.6
failure-0.1.1
failure_derive-0.1.1
filetime-0.1.15
flate2-1.0.1
fnv-1.0.6
foreign-types-0.3.2
foreign-types-shared-0.1.1
fs2-0.4.3
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
git2-0.6.11
git2-curl-0.7.0
glob-0.2.11
globset-0.3.0
hamcrest-0.1.1
hex-0.3.1
home-0.3.2
humantime-1.1.1
idna-0.1.4
ignore-0.4.1
itoa-0.4.1
jobserver-0.1.11
kernel32-sys-0.2.2
lazy_static-1.0.0
lazycell-0.6.0
libc-0.2.40
libgit2-sys-0.6.19
libssh2-sys-0.2.6
libz-sys-1.0.18
log-0.3.9
log-0.4.1
matches-0.1.6
memchr-0.1.11
memchr-2.0.1
miniz-sys-0.1.10
miow-0.3.1
num-0.1.42
num-bigint-0.1.43
num-complex-0.1.43
num-integer-0.1.36
num-iter-0.1.35
num-rational-0.1.42
num-traits-0.2.2
num_cpus-1.8.0
openssl-0.10.6
openssl-probe-0.1.2
openssl-sys-0.9.28
percent-encoding-1.0.1
pkg-config-0.3.9
proc-macro2-0.3.6
quick-error-1.2.1
quote-0.3.15
quote-0.5.1
rand-0.4.2
redox_syscall-0.1.37
redox_termios-0.1.1
regex-0.1.80
regex-0.2.10
regex-syntax-0.3.9
regex-syntax-0.5.3
remove_dir_all-0.5.0
rustc-demangle-0.1.7
rustc-serialize-0.3.24
same-file-1.0.2
schannel-0.1.11
scoped-tls-0.1.1
scopeguard-0.3.3
semver-0.9.0
semver-parser-0.7.0
serde-1.0.37
serde_derive-1.0.37
serde_derive_internals-0.23.0
serde_ignored-0.0.4
serde_json-1.0.13
shell-escape-0.1.4
socket2-0.3.4
strsim-0.6.0
syn-0.11.11
syn-0.13.1
synom-0.11.3
synstructure-0.6.1
tar-0.4.14
tempdir-0.3.7
termcolor-0.3.6
termion-1.5.1
thread-id-2.0.0
thread_local-0.2.7
thread_local-0.3.5
toml-0.4.6
ucd-util-0.1.1
unicode-bidi-0.3.4
unicode-normalization-0.1.5
unicode-xid-0.0.4
unicode-xid-0.1.0
unreachable-1.0.0
url-1.7.0
userenv-sys-0.2.0
utf8-ranges-0.1.3
utf8-ranges-1.0.0
vcpkg-0.2.2
void-1.0.2
walkdir-2.1.4
winapi-0.2.8
winapi-0.3.4
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-0.1.6"

inherit cargo bash-completion-r1 versionator

BOOTSTRAP_VERSION="0.$(($(get_version_component_range 2) - 1)).0"

DESCRIPTION="The Rust's package manager"
HOMEPAGE="http://crates.io"
SRC_URI="https://github.com/rust-lang/cargo/archive/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	x86?   (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-i686-unknown-linux-gnu.tar.gz
	)
	amd64? (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-x86_64-unknown-linux-gnu.tar.gz
	)
	arm64? (
		https://static.rust-lang.org/dist/cargo-${BOOTSTRAP_VERSION}-aarch64-unknown-linux-gnu.tar.gz
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
	>=virtual/rust-1.19.0
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
	${cargo} build --release

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
