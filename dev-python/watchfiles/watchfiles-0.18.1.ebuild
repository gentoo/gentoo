# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{8..11} pypy3 )

CRATES="
	autocfg-1.1.0
	bitflags-1.3.2
	cfg-if-1.0.0
	crossbeam-channel-0.5.4
	crossbeam-utils-0.8.8
	filetime-0.2.16
	fsevent-sys-4.1.0
	indoc-1.0.4
	inotify-0.9.6
	inotify-sys-0.1.5
	kqueue-1.0.5
	kqueue-sys-1.0.3
	lazy_static-1.4.0
	libc-0.2.124
	lock_api-0.4.7
	log-0.4.16
	memoffset-0.6.5
	mio-0.8.2
	miow-0.3.7
	notify-5.0.0
	ntapi-0.3.7
	once_cell-1.10.0
	parking_lot-0.12.0
	parking_lot_core-0.9.2
	proc-macro2-1.0.37
	pyo3-0.17.3
	pyo3-build-config-0.17.3
	pyo3-ffi-0.17.3
	pyo3-macros-0.17.3
	pyo3-macros-backend-0.17.3
	quote-1.0.18
	redox_syscall-0.2.13
	same-file-1.0.6
	scopeguard-1.1.0
	smallvec-1.8.0
	syn-1.0.91
	target-lexicon-0.12.3
	unicode-xid-0.2.2
	unindent-0.1.8
	walkdir-2.3.2
	wasi-0.11.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.34.0
	windows_aarch64_msvc-0.34.0
	windows_i686_gnu-0.34.0
	windows_i686_msvc-0.34.0
	windows_x86_64_gnu-0.34.0
	windows_x86_64_msvc-0.34.0
"

inherit cargo distutils-r1

DESCRIPTION="Simple, modern file watching and code reload in Python"
HOMEPAGE="
	https://pypi.org/project/watchfiles/
	https://github.com/samuelcolvin/watchfiles/
"
SRC_URI="
	https://github.com/samuelcolvin/watchfiles/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="MIT"
# crates
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions Artistic-2"
LICENSE+=" CC0-1.0 ISC MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	=dev-python/anyio-3*[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		dev-python/dirty-equals[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

# enjoy Rust
QA_FLAGS_IGNORED=".*/_rust_notify.*"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# fix version number
	sed -i -e "/^version/s:0\.0\.0:${PV}:" Cargo.toml || die
}

python_test() {
	rm -rf watchfiles || die
	epytest
}
