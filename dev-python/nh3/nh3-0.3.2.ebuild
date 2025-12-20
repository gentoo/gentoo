# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

RUST_MIN_VER="1.85.0"
CRATES="
	aliasable@0.1.3
	ammonia@4.1.2
	autocfg@1.5.0
	bitflags@2.10.0
	cc@1.2.43
	cfg-if@1.0.4
	cssparser-macros@0.6.1
	cssparser@0.35.0
	displaydoc@0.2.5
	dtoa-short@0.3.5
	dtoa@1.0.10
	find-msvc-tools@0.1.4
	form_urlencoded@1.2.2
	futf@0.1.5
	heck@0.4.1
	heck@0.5.0
	html5ever@0.35.0
	icu_collections@2.1.1
	icu_locale_core@2.1.1
	icu_normalizer@2.1.1
	icu_normalizer_data@2.1.1
	icu_properties@2.1.1
	icu_properties_data@2.1.1
	icu_provider@2.1.1
	idna@1.1.0
	idna_adapter@1.2.1
	indoc@2.0.7
	itoa@1.0.15
	libc@0.2.177
	litemap@0.8.1
	lock_api@0.4.14
	log@0.4.28
	mac@0.1.1
	maplit@1.0.2
	markup5ever@0.35.0
	match_token@0.35.0
	memoffset@0.9.1
	new_debug_unreachable@1.0.6
	once_cell@1.21.3
	ouroboros@0.18.5
	ouroboros_macro@0.18.5
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	percent-encoding@2.3.2
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_macros@0.11.3
	phf_shared@0.11.3
	portable-atomic@1.11.1
	potential_utf@0.1.4
	precomputed-hash@0.1.1
	proc-macro2-diagnostics@0.10.1
	proc-macro2@1.0.103
	pyo3-build-config@0.27.1
	pyo3-ffi@0.27.1
	pyo3-macros-backend@0.27.1
	pyo3-macros@0.27.1
	pyo3@0.27.1
	python3-dll-a@0.2.14
	quote@1.0.41
	rand@0.8.5
	rand_core@0.6.4
	redox_syscall@0.5.18
	rustversion@1.0.22
	scopeguard@1.2.0
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	shlex@1.3.0
	siphasher@1.0.1
	smallvec@1.15.1
	stable_deref_trait@1.2.1
	static_assertions@1.1.0
	string_cache@0.8.9
	string_cache_codegen@0.5.4
	syn@2.0.108
	synstructure@0.13.2
	target-lexicon@0.13.3
	tendril@0.4.3
	tinystr@0.8.2
	unicode-ident@1.0.22
	unindent@0.2.4
	url@2.5.7
	utf-8@0.7.6
	utf8_iter@1.0.4
	version_check@0.9.5
	web_atoms@0.1.3
	windows-link@0.2.1
	writeable@0.6.2
	yansi@1.0.1
	yoke-derive@0.8.1
	yoke@0.8.1
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerotrie@0.2.3
	zerovec-derive@0.11.2
	zerovec@0.11.5
"

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
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/nh3/nh3.*.so"
