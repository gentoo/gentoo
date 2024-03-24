# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=maturin
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	atomic_refcell@0.1.13
	autocfg@1.1.0
	bitflags@1.3.2
	bumpalo@3.14.0
	cfg-if@1.0.0
	getrandom@0.1.16
	heck@0.4.1
	indoc@2.0.4
	itoa@1.0.10
	js-sys@0.3.68
	libc@0.2.153
	lock_api@0.4.11
	log@0.4.20
	memoffset@0.9.0
	once_cell@1.19.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	ppv-lite86@0.2.17
	proc-macro2@1.0.78
	pyo3-build-config@0.20.2
	pyo3-ffi@0.20.2
	pyo3-macros-backend@0.20.2
	pyo3-macros@0.20.2
	pyo3@0.20.2
	quote@1.0.35
	rand@0.7.3
	rand_chacha@0.2.2
	rand_core@0.5.1
	rand_hc@0.2.0
	redox_syscall@0.4.1
	ryu@1.0.16
	scopeguard@1.2.0
	serde@1.0.196
	serde_derive@1.0.196
	serde_json@1.0.113
	smallstr@0.3.0
	smallvec@1.13.1
	syn@2.0.48
	target-lexicon@0.12.13
	thiserror-impl@1.0.57
	thiserror@1.0.57
	unicode-ident@1.0.12
	unindent@0.2.3
	wasi@0.9.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.91
	wasm-bindgen-macro-support@0.2.91
	wasm-bindgen-macro@0.2.91
	wasm-bindgen-shared@0.2.91
	wasm-bindgen@0.2.91
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	yrs@0.17.4
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Python bindings for Yrs"
HOMEPAGE="https://github.com/jupyter-server/pycrdt"

SRC_URI="${SRC_URI}
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
LICENSE+="
	Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"

SLOT="0"
KEYWORDS="~amd64"

IUSE=""
RDEPEND=""
distutils_enable_tests pytest
