# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CARGO_SNAPSHOT_DATE="2016-03-21"
CARGO_INDEX_COMMIT="64a9f2f594cefc2ca652e0cecf7ce6e41c0279ee"
CRATES="advapi32-sys-0.1.2
aho-corasick-0.5.1
bitflags-0.1.1
bufstream-0.1.1
cmake-0.1.16
crossbeam-0.2.8
curl-0.3.0
curl-sys-0.2.0
docopt-0.6.78
env_logger-0.3.2
filetime-0.1.10
flate2-0.2.13
fs2-0.2.3
gcc-0.3.26
gdi32-sys-0.1.1
git2-0.4.3
git2-curl-0.5.0
glob-0.2.11
hamcrest-0.1.0
idna-0.1.0
kernel32-sys-0.2.1
libc-0.2.8
libgit2-sys-0.4.3
libressl-pnacl-sys-2.1.6
libssh2-sys-0.1.37
libz-sys-1.0.2
log-0.3.5
matches-0.1.2
memchr-0.1.10
miniz-sys-0.1.7
miow-0.1.2
net2-0.2.24
nom-1.2.2
num-0.1.31
num_cpus-0.2.11
openssl-sys-0.7.8
pkg-config-0.3.8
pnacl-build-helper-1.4.10
rand-0.3.14
regex-0.1.58
regex-syntax-0.3.0
rustc-serialize-0.3.18
semver-0.2.3
strsim-0.3.0
tar-0.4.5
tempdir-0.3.4
term-0.4.4
toml-0.1.30
unicode-bidi-0.2.3
unicode-normalization-0.1.2
url-1.1.0
user32-sys-0.1.2
utf8-ranges-0.1.3
winapi-0.2.6
winapi-build-0.1.1
"

inherit cargo bash-completion-r1

DESCRIPTION="The Rust's package manager"
HOMEPAGE="http://crates.io"
SRC_URI="https://github.com/rust-lang/cargo/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rust-lang/crates.io-index/archive/${CARGO_INDEX_COMMIT}.tar.gz -> cargo-registry-${CARGO_INDEX_COMMIT}.tar.gz
	$(cargo_crate_uris ${CRATES})
	x86?   (
		https://static.rust-lang.org/cargo-dist/${CARGO_SNAPSHOT_DATE}/cargo-nightly-i686-unknown-linux-gnu.tar.gz ->
		cargo-snapshot-x86-${CARGO_SNAPSHOT_DATE}.tar.gz
	)
	amd64? (
		https://static.rust-lang.org/cargo-dist/${CARGO_SNAPSHOT_DATE}/cargo-nightly-x86_64-unknown-linux-gnu.tar.gz ->
		cargo-snapshot-amd64-${CARGO_SNAPSHOT_DATE}.tar.gz
	)"

RESTRICT="mirror"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

COMMON_DEPEND="sys-libs/zlib
	dev-libs/openssl:0=
	net-libs/libssh2
	net-libs/http-parser"
RDEPEND="${COMMON_DEPEND}
	!dev-util/cargo-bin
	net-misc/curl[ssl]"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/rust-1.1.0:stable
	dev-util/cmake
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/findutils
	sys-apps/sed"

src_configure() {
	# Cargo only supports these GNU triples:
	# - Linux: <arch>-unknown-linux-gnu
	# - MacOS: <arch>-apple-darwin
	# - Windows: <arch>-pc-windows-gnu
	# where <arch> could be 'x86_64' (amd64) or 'i686' (x86)
	use amd64 && CTARGET="x86_64-unknown-linux-gnu"
	use x86 && CTARGET="i686-unknown-linux-gnu"

	# NOTE: 'disable-nightly' is used by crates (such as 'matches') to entirely
	# skip their internal libraries that make use of unstable rustc features.
	# Don't use 'enable-nightly' with a stable release of rustc as DEPEND,
	# otherwise you could get compilation issues.
	# see: github.com/gentoo/gentoo-rust/issues/13
	local myeconfargs=(
		--host=${CTARGET}
		--build=${CTARGET}
		--target=${CTARGET}
		--enable-optimize
		--disable-nightly
		--disable-verify-install
		--disable-debug
		--disable-cross-tests
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# Building sources
	export CARGO_HOME="${ECARGO_HOME}"
	emake VERBOSE=1 PKG_CONFIG_PATH=""

	# Building HTML documentation
	use doc && emake doc
}

src_install() {
	emake prepare-image-${CTARGET} IMGDIR_${CTARGET}="${ED}/usr"

	# Install HTML documentation
	use doc && HTML_DOCS=("target/doc")
	einstalldocs

	dobashcomp "${ED}"/usr/etc/bash_completion.d/cargo
	rm -rf "${ED}"/usr/etc || die
}

src_test() {
	# Running unit tests
	# NOTE: by default 'make test' uses the copy of cargo (v0.0.1-pre-nighyly)
	# from the installer snapshot instead of the version just built, so the
	# ebuild needs to override the value of CFG_LOCAL_CARGO to avoid false
	# positives from unit tests.
	emake test \
		CFG_ENABLE_OPTIMIZE=1 \
		VERBOSE=1 \
		CFG_LOCAL_CARGO="${WORKDIR}"/${P}/target/${CTARGET}/release/cargo
}
