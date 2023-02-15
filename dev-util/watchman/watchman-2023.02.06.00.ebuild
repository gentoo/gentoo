# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# These must be bumped together:
# dev-cpp/edencommon
# dev-cpp/folly
# dev-util/watchman

# TODO: Split into different variables then combine for each component?
# Not all is in rust/ dir.
# Rust components:
# - thirdparty/deelevate_binding/Cargo.toml
# - rust/watchman_client/Cargo.toml
# - rust/serde_bser/Cargo.toml
# - cli/Cargo.toml
CRATES="
ahash-0.3.8
aho-corasick-0.7.20
android_system_properties-0.1.5
ansi_term-0.12.1
anyhow-1.0.68
atty-0.2.14
autocfg-1.1.0
base64-0.10.1
bitflags-1.3.2
bumpalo-3.12.0
byteorder-1.4.3
bytes-1.3.0
cc-1.0.78
cfg-if-1.0.0
chrono-0.4.23
clap-2.34.0
codespan-reporting-0.11.1
const-random-0.1.15
const-random-macro-0.1.15
core-foundation-sys-0.8.3
crossbeam-0.8.2
crossbeam-channel-0.5.6
crossbeam-deque-0.8.2
crossbeam-epoch-0.9.13
crossbeam-queue-0.3.8
crossbeam-utils-0.8.14
crunchy-0.2.2
cxx-1.0.87
cxxbridge-flags-1.0.87
cxxbridge-macro-1.0.87
cxx-build-1.0.87
deelevate-0.1.1
dirs-4.0.0
dirs-sys-0.3.7
duct-0.13.6
either-1.8.0
embed-resource-1.8.0
filedescriptor-0.7.3
fnv-1.0.7
futures-0.1.31
futures-0.3.25
futures-channel-0.3.25
futures-core-0.3.25
futures-executor-0.3.25
futures-io-0.3.25
futures-macro-0.3.25
futures-sink-0.3.25
futures-task-0.3.25
futures-util-0.3.25
getrandom-0.1.16
getrandom-0.2.8
heck-0.3.3
hermit-abi-0.1.19
hermit-abi-0.2.6
iana-time-zone-0.1.53
iana-time-zone-haiku-0.1.1
itoa-1.0.5
js-sys-0.3.60
jwalk-0.6.2
lazy_static-1.4.0
libc-0.2.139
link-cplusplus-1.0.8
lock_api-0.4.9
log-0.4.17
maplit-1.0.2
maybe-uninit-2.0.0
memchr-2.5.0
memmem-0.1.1
memoffset-0.6.5
memoffset-0.7.1
mio-0.8.5
nix-0.23.2
nom-5.1.2
ntapi-0.4.0
num-0.2.1
num-bigint-0.2.6
num-complex-0.2.4
num_cpus-1.15.0
num-derive-0.2.5
num-integer-0.1.45
num-iter-0.1.43
num-rational-0.2.4
num-traits-0.2.15
once_cell-1.17.0
ordered-float-1.1.1
os_pipe-1.1.2
parking_lot-0.12.1
parking_lot_core-0.9.6
pathsearch-0.2.0
phf-0.11.1
phf_codegen-0.11.1
phf_generator-0.11.1
phf_shared-0.11.1
pin-project-lite-0.2.9
pin-utils-0.1.0
ppv-lite86-0.2.17
proc-macro2-0.4.30
proc-macro2-1.0.50
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.20+deprecated
quote-0.6.13
quote-1.0.23
rand-0.7.3
rand-0.8.5
rand_chacha-0.2.2
rand_core-0.5.1
rand_core-0.6.4
rand_hc-0.2.0
rayon-1.6.1
rayon-core-1.10.1
redox_syscall-0.2.16
redox_users-0.4.3
regex-1.7.1
regex-syntax-0.6.28
rustc_version-0.4.0
ryu-1.0.12
scopeguard-1.1.0
scratch-1.0.3
semver-0.9.0
semver-1.0.16
semver-parser-0.7.0
serde-1.0.152
serde_bytes-0.11.8
serde_derive-1.0.152
serde_json-1.0.91
shared_child-1.0.0
shared_library-0.1.9
signal-hook-0.1.17
signal-hook-registry-1.4.0
siphasher-0.3.10
slab-0.4.7
smallvec-0.6.14
smallvec-1.10.0
socket2-0.4.7
strsim-0.8.0
structopt-0.3.26
structopt-derive-0.4.18
syn-0.15.44
syn-1.0.107
sysinfo-0.26.9
tabular-0.2.0
termcolor-1.2.0
terminfo-0.7.5
termios-0.3.3
termwiz-0.8.0
textwrap-0.11.0
thiserror-1.0.38
thiserror-impl-1.0.38
time-0.1.45
tiny-keccak-2.0.2
tokio-1.24.2
tokio-macros-1.8.2
tokio-util-0.6.10
toml-0.5.11
unicode-ident-1.0.6
unicode-segmentation-1.10.0
unicode-width-0.1.10
unicode-xid-0.1.0
utf8parse-0.1.1
vec_map-0.8.2
vergen-3.2.0
version_check-0.9.4
vswhom-0.1.0
vswhom-sys-0.1.2
vtparse-0.2.2
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.11.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
wasm-bindgen-0.2.83
wasm-bindgen-backend-0.2.83
wasm-bindgen-macro-0.2.83
wasm-bindgen-macro-support-0.2.83
wasm-bindgen-shared-0.2.83
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows_aarch64_gnullvm-0.42.1
windows_aarch64_msvc-0.42.1
windows_i686_gnu-0.42.1
windows_i686_msvc-0.42.1
windows-sys-0.42.0
windows_x86_64_gnu-0.42.1
windows_x86_64_gnullvm-0.42.1
windows_x86_64_msvc-0.42.1
winreg-0.10.1
xi-unicode-0.2.1
"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
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
	"${FILESDIR}"/${PN}-2023.01.16.00-python-working-dir.patch
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
