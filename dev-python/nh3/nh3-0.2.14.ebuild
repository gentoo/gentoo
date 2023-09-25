# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ammonia@3.3.0
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	form_urlencoded@1.2.0
	futf@0.1.5
	getrandom@0.2.10
	html5ever@0.26.0
	idna@0.4.0
	indoc@1.0.9
	libc@0.2.147
	lock_api@0.4.10
	log@0.4.19
	mac@0.1.1
	maplit@1.0.2
	markup5ever@0.11.0
	memoffset@0.9.0
	new_debug_unreachable@1.0.4
	once_cell@1.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	percent-encoding@2.3.0
	phf@0.10.1
	phf_codegen@0.10.0
	phf_generator@0.10.0
	phf_shared@0.10.0
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	proc-macro2@1.0.63
	pyo3-build-config@0.19.1
	pyo3-ffi@0.19.1
	pyo3-macros-backend@0.19.1
	pyo3-macros@0.19.1
	pyo3@0.19.1
	quote@1.0.29
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.3.5
	scopeguard@1.1.0
	serde@1.0.166
	siphasher@0.3.10
	smallvec@1.10.0
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	syn@1.0.109
	target-lexicon@0.12.8
	tendril@0.4.3
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	unicode-bidi@0.3.13
	unicode-ident@1.0.10
	unicode-normalization@0.1.22
	unindent@0.1.11
	url@2.4.0
	utf-8@0.7.6
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.48.1
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.48.0
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit cargo distutils-r1 pypi

DESCRIPTION="Ammonia HTML sanitizer Python binding"
HOMEPAGE="
	https://github.com/messense/nh3/
	https://pypi.org/project/nh3/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~x86"

distutils_enable_tests pytest

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/nh3/nh3.*.so"
