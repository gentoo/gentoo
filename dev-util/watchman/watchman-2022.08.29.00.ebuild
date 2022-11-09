# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# dev-cpp/edencommon
# dev-cpp/folly
# dev-util/watchman

# TODO: Split into different variables then combine for each component?
# Not all is in rust/ dir.
# Rust components: watchman/cli watchman/rust/serde_bser watchman/rust/watchman_client
CRATES="
ahash-0.3.8
ansi_term-0.12.1
anyhow-1.0.55
atty-0.2.14
autocfg-1.1.0
bitflags-1.3.2
byteorder-1.4.3
bytes-1.1.0
cfg-if-1.0.0
clap-2.34.0
const-random-0.1.13
const-random-macro-0.1.13
crossbeam-0.8.1
crossbeam-channel-0.5.2
crossbeam-deque-0.8.1
crossbeam-epoch-0.9.7
crossbeam-queue-0.3.4
crossbeam-utils-0.8.7
crunchy-0.2.2
either-1.6.1
futures-0.1.31
futures-0.3.21
futures-channel-0.3.21
futures-core-0.3.21
futures-executor-0.3.21
futures-io-0.3.21
futures-macro-0.3.21
futures-sink-0.3.21
futures-task-0.3.21
futures-util-0.3.21
getrandom-0.2.5
heck-0.3.3
hermit-abi-0.1.19
jwalk-0.6.0
lazy_static-1.4.0
libc-0.2.119
lock_api-0.4.6
log-0.4.14
maplit-1.0.2
memchr-2.4.1
memoffset-0.6.5
mio-0.8.0
miow-0.3.7
ntapi-0.3.7
num_cpus-1.13.1
once_cell-1.9.0
parking_lot-0.12.0
parking_lot_core-0.9.1
pin-project-lite-0.2.8
pin-utils-0.1.0
proc-macro2-1.0.36
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.19
quote-1.0.15
rayon-1.5.1
rayon-core-1.9.1
redox_syscall-0.2.10
scopeguard-1.1.0
serde-1.0.136
serde_derive-1.0.136
signal-hook-registry-1.4.0
slab-0.4.5
smallvec-1.8.0
socket2-0.4.4
strsim-0.8.0
structopt-0.3.26
structopt-derive-0.4.18
syn-1.0.86
textwrap-0.11.0
thiserror-1.0.30
thiserror-impl-1.0.30
tiny-keccak-2.0.2
tokio-1.17.0
tokio-macros-1.7.0
tokio-util-0.6.9
unicode-segmentation-1.9.0
unicode-width-0.1.9
unicode-xid-0.2.2
vec_map-0.8.2
version_check-0.9.4
wasi-0.10.2+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
windows_aarch64_msvc-0.32.0
windows_i686_gnu-0.32.0
windows_i686_msvc-0.32.0
windows-sys-0.32.0
windows_x86_64_gnu-0.32.0
windows_x86_64_msvc-0.32.0
"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit cargo cmake distutils-r1 tmpfiles

DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman/"
SRC_URI="https://github.com/facebook/watchman/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="llvm-libunwind python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# See https://github.com/facebook/watchman/blob/main/CMakeLists.txt#L342 for libevent
RDEPEND="
	dev-libs/libevent:=
	dev-libs/libpcre2
	~dev-cpp/edencommon-${PV}:=
	~dev-cpp/folly-${PV}:=
	dev-cpp/glog:=
	>=dev-libs/libfmt-8.1.1-r1:=
	dev-libs/openssl:=
	llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
	python? ( ${PYTHON_DEPS} )"
# TODO: Make gtest test-only (needs a fair bit of patching)
DEPEND="${RDEPEND}
	dev-cpp/gtest"

PATCHES=(
	"${FILESDIR}"/${PN}-2022.07.04.00-python-working-dir.patch
	"${FILESDIR}"/${PN}-2022.02.28.00-libatomic.patch
	"${FILESDIR}"/${PN}-2022.08.08.00-musl-fsword-fix.patch
)

# Rust utility
QA_FLAGS_IGNORED="usr/bin/watchmanctl"

distutils_enable_tests unittest

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	# https://github.com/facebook/watchman/blob/789678cf9855fb07b402afb75b01e4f8786deba2/build/fbcode_builder/CMake/RustStaticLibrary.cmake#L17
	export RUST_VENDORED_CRATES_DIR="${ECARGO_VENDOR}"
	export RUST_CARGO_HOME="${ECARGO_HOME}"
	export CARGO_HOME="${ECARGO_HOME}"
	# Build system already handles avoiding Rust-jobs-while-CMake-jobs-spawned issue
	# https://github.com/facebook/watchman/blob/789678cf9855fb07b402afb75b01e4f8786deba2/build/fbcode_builder/CMake/RustStaticLibrary.cmake#L69
	# so no need to force -j1 via cargo jobs

	local mycmakeargs=(
		# Rust wrangling
		-DUSE_CARGO_VENDOR=ON
		-DGENERATE_CARGO_VENDOR_CONFIG=OFF
		-DRUST_CARGO_HOME="${RUST_CARGO_HOME}"

		# General bits
		-DWATCHMAN_STATE_DIR="${EPREFIX}"/run/watchman
		-DWATCHMAN_VERSION_OVERRIDE=${PV}

		# Fails to build against fbthrift for now in libatomic troubles
		-DENABLE_EDEN_SUPPORT=OFF

		# We handle this ourselves
		-DCMAKE_DISABLE_FIND_PACKAGE_Python3=ON
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use python ; then
		pushd watchman/python >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_test() {
	cmake_src_test

	if use python ; then
		pushd watchman/python >/dev/null || die
		distutils-r1_src_test
		popd >/dev/null || die
	fi
}

src_install() {
	cmake_src_install

	newtmpfiles "${FILESDIR}"/watchman.tmpfiles watchman.conf

	if use python ; then
		pushd watchman/python >/dev/null || die
		distutils-r1_src_install
		popd >/dev/null || die
	fi
}

pkg_postinst() {
	tmpfiles_process watchman.conf
}
