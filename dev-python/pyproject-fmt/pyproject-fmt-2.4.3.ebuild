# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..13} )

CRATES="
	ahash@0.8.11
	aho-corasick@1.1.3
	any_ascii@0.1.7
	arc-swap@1.7.1
	autocfg@1.4.0
	beef@0.5.2
	bstr@1.10.0
	cfg-if@1.0.0
	countme@3.0.1
	deranged@0.3.11
	derivative@2.2.0
	either@1.13.0
	equivalent@1.0.1
	fnv@1.0.7
	form_urlencoded@1.2.1
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-timer@3.0.3
	futures-util@0.3.31
	futures@0.3.31
	getrandom@0.2.15
	glob@0.3.1
	globset@0.4.15
	hashbrown@0.14.5
	hashbrown@0.15.0
	heck@0.5.0
	idna@0.5.0
	indexmap@2.6.0
	indoc@2.0.5
	itertools@0.10.5
	itoa@1.0.11
	lexical-sort@0.3.1
	libc@0.2.159
	log@0.4.22
	logos-derive@0.12.1
	logos@0.12.1
	memchr@2.7.4
	memoffset@0.9.1
	num-conv@0.1.0
	once_cell@1.20.2
	pep440_rs@0.6.6
	pep508_rs@0.6.1
	percent-encoding@2.3.1
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	portable-atomic@1.9.0
	powerfmt@0.2.0
	proc-macro-crate@3.2.0
	proc-macro2@1.0.87
	pyo3-build-config@0.22.5
	pyo3-ffi@0.22.5
	pyo3-macros-backend@0.22.5
	pyo3-macros@0.22.5
	pyo3@0.22.5
	quote@1.0.37
	regex-automata@0.4.8
	regex-syntax@0.6.29
	regex-syntax@0.8.5
	regex@1.11.0
	relative-path@1.9.3
	rowan@0.15.16
	rstest@0.23.0
	rstest_macros@0.23.0
	rustc-hash@1.1.0
	rustc_version@0.4.1
	ryu@1.0.18
	semver@1.0.23
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	slab@0.4.9
	syn@1.0.109
	syn@2.0.79
	taplo@0.13.2
	target-lexicon@0.12.16
	text-size@1.1.1
	thiserror-impl@1.0.64
	thiserror@1.0.64
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinyvec@1.8.0
	tinyvec_macros@0.1.1
	toml_datetime@0.6.8
	toml_edit@0.22.22
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing@0.1.40
	unicode-bidi@0.3.17
	unicode-ident@1.0.13
	unicode-normalization@0.1.24
	unicode-width@0.1.14
	unindent@0.2.3
	unscanny@0.1.0
	url@2.5.2
	urlencoding@2.1.3
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	winnow@0.6.20
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
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
	Apache-2.0-with-LLVM-exceptions ISC MIT Unicode-DFS-2016
	|| ( Apache-2.0 BSD-2 )
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/tomli-2.0.2[${PYTHON_USEDEP}]
	' 3.10)
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
	cargo_src_test
}
