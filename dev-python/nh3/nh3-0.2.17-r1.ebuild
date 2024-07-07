# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ammonia@4.0.0
	autocfg@1.2.0
	bitflags@1.3.2
	cfg-if@1.0.0
	form_urlencoded@1.2.1
	futf@0.1.5
	getrandom@0.2.12
	heck@0.4.1
	html5ever@0.27.0
	idna@0.5.0
	indoc@2.0.5
	libc@0.2.153
	lock_api@0.4.11
	log@0.4.21
	mac@0.1.1
	maplit@1.0.2
	markup5ever@0.12.0
	memoffset@0.9.0
	new_debug_unreachable@1.0.6
	once_cell@1.19.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	percent-encoding@2.3.1
	phf@0.11.2
	phf_codegen@0.11.2
	phf_generator@0.10.0
	phf_generator@0.11.2
	phf_shared@0.10.0
	phf_shared@0.11.2
	portable-atomic@1.6.0
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	proc-macro2@1.0.79
	pyo3-build-config@0.21.0
	pyo3-ffi@0.21.0
	pyo3-macros-backend@0.21.0
	pyo3-macros@0.21.0
	pyo3@0.21.0
	quote@1.0.35
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.4.1
	scopeguard@1.2.0
	serde@1.0.197
	serde_derive@1.0.197
	siphasher@0.3.11
	smallvec@1.13.2
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	syn@2.0.55
	target-lexicon@0.12.14
	tendril@0.4.3
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unindent@0.2.3
	url@2.5.0
	utf-8@0.7.6
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..13} )

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
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

distutils_enable_tests pytest

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/nh3/nh3.*.so"

src_prepare() {
	distutils-r1_src_prepare

	# force unstable ABI to workaround stable ABI crash in py3.13
	# https://github.com/PyO3/pyo3/issues/4311
	sed -i -e 's:"abi3-py37",::' Cargo.toml || die
	export UNSAFE_PYO3_SKIP_VERSION_CHECK=1
}
