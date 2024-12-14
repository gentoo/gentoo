# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ammonia@4.0.0
	autocfg@1.4.0
	bitflags@2.6.0
	byteorder@1.5.0
	cc@1.2.1
	cfg-if@1.0.0
	displaydoc@0.2.5
	form_urlencoded@1.2.1
	futf@0.1.5
	getrandom@0.2.15
	heck@0.5.0
	html5ever@0.27.0
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	indoc@2.0.5
	libc@0.2.166
	litemap@0.7.4
	lock_api@0.4.12
	log@0.4.22
	mac@0.1.1
	maplit@1.0.2
	markup5ever@0.12.1
	memoffset@0.9.1
	new_debug_unreachable@1.0.6
	once_cell@1.20.2
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	percent-encoding@2.3.1
	phf@0.11.2
	phf_codegen@0.11.2
	phf_generator@0.10.0
	phf_generator@0.11.2
	phf_shared@0.10.0
	phf_shared@0.11.2
	portable-atomic@1.10.0
	ppv-lite86@0.2.20
	precomputed-hash@0.1.1
	proc-macro2@1.0.92
	pyo3-build-config@0.23.2
	pyo3-ffi@0.23.2
	pyo3-macros-backend@0.23.2
	pyo3-macros@0.23.2
	pyo3@0.23.2
	python3-dll-a@0.2.10
	quote@1.0.37
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	redox_syscall@0.5.7
	scopeguard@1.2.0
	serde@1.0.215
	serde_derive@1.0.215
	shlex@1.3.0
	siphasher@0.3.11
	smallvec@1.13.2
	stable_deref_trait@1.2.0
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	syn@2.0.89
	synstructure@0.13.1
	target-lexicon@0.12.16
	tendril@0.4.3
	tinystr@0.7.6
	unicode-ident@1.0.14
	unindent@0.2.3
	url@2.5.4
	utf-8@0.7.6
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	write16@1.0.0
	writeable@0.5.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
	zerofrom-derive@0.1.5
	zerofrom@0.1.5
	zerovec-derive@0.10.3
	zerovec@0.10.4
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
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~loong ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

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
