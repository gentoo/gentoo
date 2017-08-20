# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CARGO_SNAPSHOT_DATE="2016-09-01"
CRATES="
advapi32-sys-0.2.0
aho-corasick-0.5.3
aho-corasick-0.6.3
backtrace-0.3.2
backtrace-sys-0.1.11
bitflags-0.9.1
bufstream-0.1.3
cargotest-0.1.0
cfg-if-0.1.0
cmake-0.1.24
crates-io-0.9.0
crossbeam-0.2.10
curl-0.4.6
curl-sys-0.3.12
dbghelp-sys-0.2.0
docopt-0.7.0
dtoa-0.4.1
env_logger-0.4.3
error-chain-0.10.0
filetime-0.1.10
flate2-0.2.19
foreign-types-0.2.0
fs2-0.4.1
gcc-0.3.50
gdi32-sys-0.2.0
git2-0.6.6
git2-curl-0.7.0
glob-0.2.11
hamcrest-0.1.1
idna-0.1.2
itoa-0.3.1
jobserver-0.1.6
kernel32-sys-0.2.2
lazy_static-0.2.8
libc-0.2.23
libgit2-sys-0.6.12
libssh2-sys-0.2.6
libz-sys-1.0.14
log-0.3.8
matches-0.1.4
memchr-0.1.11
memchr-1.0.1
miniz-sys-0.1.9
miow-0.2.1
net2-0.2.29
num-0.1.37
num-bigint-0.1.37
num-complex-0.1.37
num-integer-0.1.34
num-iter-0.1.33
num-rational-0.1.36
num-traits-0.1.37
num_cpus-1.5.0
openssl-0.9.13
openssl-probe-0.1.1
openssl-sys-0.9.13
pkg-config-0.3.9
psapi-sys-0.1.0
quote-0.3.15
rand-0.3.15
regex-0.1.80
regex-0.2.2
regex-syntax-0.3.9
regex-syntax-0.4.1
rustc-demangle-0.1.4
rustc-serialize-0.3.24
scoped-tls-0.1.0
semver-0.7.0
semver-parser-0.7.0
serde-1.0.8
serde_derive-1.0.8
serde_derive_internals-0.15.1
serde_ignored-0.0.3
serde_json-1.0.2
shell-escape-0.1.3
strsim-0.6.0
syn-0.11.11
synom-0.11.3
tar-0.4.13
tempdir-0.3.5
term-0.4.5
thread-id-2.0.0
thread-id-3.1.0
thread_local-0.2.7
thread_local-0.3.3
toml-0.4.1
unicode-bidi-0.3.3
unicode-normalization-0.1.4
unicode-xid-0.0.4
unreachable-0.1.1
url-1.4.1
user32-sys-0.2.0
utf8-ranges-0.1.3
utf8-ranges-1.0.0
vcpkg-0.2.1
void-1.0.2
winapi-0.2.8
winapi-build-0.1.1
ws2_32-sys-0.2.1
"

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
	)"

RESTRICT="mirror"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc libressl"

if [[ ${ARCH} = "amd64" ]]; then
	TRIPLE="x86_64-unknown-linux-gnu"
else
	TRIPLE="i686-unknown-linux-gnu"
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
	>=dev-lang/rust-1.9.0:stable
	dev-util/cmake
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/findutils
	sys-apps/sed"

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
