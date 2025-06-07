# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} )

CRATES="
	ahash@0.8.12
	aho-corasick@1.1.3
	any_ascii@0.1.7
	arc-swap@1.7.1
	autocfg@1.4.0
	beef@0.5.2
	bitflags@2.9.1
	bstr@1.12.0
	cfg-if@1.0.0
	countme@3.0.1
	deranged@0.4.0
	displaydoc@0.2.5
	either@1.15.0
	equivalent@1.0.2
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures-core@0.3.31
	futures-macro@0.3.31
	futures-task@0.3.31
	futures-timer@3.0.3
	futures-util@0.3.31
	getrandom@0.3.3
	glob@0.3.2
	globset@0.4.16
	hashbrown@0.14.5
	hashbrown@0.15.3
	heck@0.5.0
	icu_collections@2.0.0
	icu_locale_core@2.0.0
	icu_normalizer@2.0.0
	icu_normalizer_data@2.0.0
	icu_properties@2.0.0
	icu_properties_data@2.0.0
	icu_provider@2.0.0
	idna@1.0.3
	idna_adapter@1.2.1
	indexmap@2.9.0
	indoc@2.0.6
	itertools@0.10.5
	itoa@1.0.15
	lexical-sort@0.3.1
	libc@0.2.172
	litemap@0.8.0
	log@0.4.27
	logos-derive@0.12.1
	logos@0.12.1
	memchr@2.7.4
	memoffset@0.9.1
	num-conv@0.1.0
	once_cell@1.21.3
	pep440_rs@0.7.3
	pep508_rs@0.8.1
	percent-encoding@2.3.1
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	portable-atomic@1.11.0
	potential_utf@0.1.2
	powerfmt@0.2.0
	proc-macro-crate@3.3.0
	proc-macro2@1.0.95
	pyo3-build-config@0.25.0
	pyo3-ffi@0.25.0
	pyo3-macros-backend@0.25.0
	pyo3-macros@0.25.0
	pyo3@0.25.0
	quote@1.0.40
	r-efi@5.2.0
	regex-automata@0.4.9
	regex-syntax@0.6.29
	regex-syntax@0.8.5
	regex@1.11.1
	relative-path@1.9.3
	rowan@0.15.16
	rstest@0.25.0
	rstest_macros@0.25.0
	rustc-hash@1.1.0
	rustc_version@0.4.1
	ryu@1.0.20
	semver@1.0.26
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.140
	slab@0.4.9
	smallvec@1.15.0
	stable_deref_trait@1.2.0
	syn@1.0.109
	syn@2.0.101
	synstructure@0.13.2
	taplo@0.13.2
	target-lexicon@0.13.2
	text-size@1.1.1
	thiserror-impl@1.0.69
	thiserror@1.0.69
	time-core@0.1.4
	time-macros@0.2.22
	time@0.3.41
	tinystr@0.8.1
	toml_datetime@0.6.9
	toml_edit@0.22.26
	tracing-attributes@0.1.28
	tracing-core@0.1.33
	tracing@0.1.41
	unicode-ident@1.0.18
	unicode-width@0.2.0
	unindent@0.2.4
	unscanny@0.1.0
	url@2.5.4
	urlencoding@2.1.3
	utf8_iter@1.0.4
	version_check@0.9.5
	wasi@0.14.2+wasi-0.2.4
	winnow@0.7.10
	wit-bindgen-rt@0.39.0
	writeable@0.6.1
	yoke-derive@0.8.0
	yoke@0.8.0
	zerocopy-derive@0.8.25
	zerocopy@0.8.25
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerotrie@0.2.2
	zerovec-derive@0.11.1
	zerovec@0.11.2
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Format your pyproject.toml file"
HOMEPAGE="
	https://github.com/tox-dev/pyproject-fmt/
	https://pypi.org/project/pyproject-fmt/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions ISC MIT Unicode-3.0
	|| ( Apache-2.0 BSD-2 )
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64 arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	~dev-python/toml-fmt-common-1.0.1[${PYTHON_USEDEP}]
"
# tox is called as a subprocess, to get targets from tox.ini
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-mock-3.10[${PYTHON_USEDEP}]
		dev-python/tox
	)
"

distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/pyproject_fmt/_lib.*.so"

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e '/strip/d' pyproject.toml || die
}

python_test_all() {
	# default features cause linking errors because they make pyo3
	# wrongly assume it's compiling a Python extension
	# https://github.com/tox-dev/toml-fmt/issues/23
	cargo_src_test --no-default-features
}
