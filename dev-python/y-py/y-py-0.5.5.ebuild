# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{9..11} )

CRATES="
	autocfg-1.1.0
	bitflags-1.3.2
	bumpalo-3.11.1
	cfg-if-1.0.0
	getrandom-0.1.16
	indoc-1.0.7
	js-sys-0.3.60
	lib0-0.12.2
	libc-0.2.138
	lock_api-0.4.9
	log-0.4.17
	once_cell-1.16.0
	parking_lot-0.12.1
	parking_lot_core-0.9.5
	ppv-lite86-0.2.17
	proc-macro2-1.0.47
	pyo3-0.16.6
	pyo3-build-config-0.16.6
	pyo3-ffi-0.16.6
	pyo3-macros-0.16.6
	pyo3-macros-backend-0.16.6
	quote-1.0.21
	rand-0.7.3
	rand_chacha-0.2.2
	rand_core-0.5.1
	rand_hc-0.2.0
	redox_syscall-0.2.16
	scopeguard-1.1.0
	smallstr-0.2.0
	smallvec-1.10.0
	syn-1.0.105
	target-lexicon-0.12.5
	thiserror-1.0.37
	thiserror-impl-1.0.37
	unicode-ident-1.0.5
	unindent-0.1.10
	wasi-0.9.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.42.0
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.42.0
	yrs-0.12.2
"

inherit cargo distutils-r1

DESCRIPTION="Python bindings to y-crdt "
HOMEPAGE="
	https://pypi.org/project/y-py/
	https://github.com/y-crdt/ypy
"
SRC_URI="
	mirror://pypi/${PN::1}/${PN}/y_py-${PV}.tar.gz
	$(cargo_crate_uris ${CRATES})
"
S="${WORKDIR}/y_py-${PV}"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016 MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/rust"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED=".*/y_py.cpython.*.so"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/furo dev-python/sphinx-autoapi

src_unpack() {
	cargo_src_unpack
}
