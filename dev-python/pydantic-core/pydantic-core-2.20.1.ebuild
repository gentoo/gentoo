# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..13} )

CRATES="
	ahash@0.8.11
	aho-corasick@1.1.3
	autocfg@1.3.0
	base64@0.21.7
	bitvec@1.0.1
	cc@1.0.101
	cfg-if@1.0.0
	enum_dispatch@0.3.13
	equivalent@1.0.1
	form_urlencoded@1.2.1
	funty@2.0.0
	getrandom@0.2.15
	hashbrown@0.14.5
	heck@0.5.0
	idna@0.5.0
	indexmap@2.2.6
	indoc@2.0.5
	itoa@1.0.11
	jiter@0.5.0
	lexical-parse-float@0.8.5
	lexical-parse-integer@0.8.6
	lexical-util@0.8.5
	libc@0.2.155
	memchr@2.7.4
	memoffset@0.9.1
	num-bigint@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	once_cell@1.19.0
	percent-encoding@2.3.1
	portable-atomic@1.6.0
	proc-macro2@1.0.86
	pyo3-build-config@0.22.0
	pyo3-ffi@0.22.0
	pyo3-macros-backend@0.22.0
	pyo3-macros@0.22.0
	pyo3@0.22.0
	python3-dll-a@0.2.10
	quote@1.0.36
	radium@0.7.0
	regex-automata@0.4.7
	regex-syntax@0.8.4
	regex@1.10.5
	rustversion@1.0.17
	ryu@1.0.18
	serde@1.0.203
	serde_derive@1.0.203
	serde_json@1.0.118
	smallvec@1.13.2
	speedate@0.14.4
	static_assertions@1.1.0
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.68
	tap@1.0.1
	target-lexicon@0.12.14
	tinyvec@1.6.1
	tinyvec_macros@0.1.1
	unicode-bidi@0.3.15
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unindent@0.2.3
	url@2.5.2
	uuid@1.9.1
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	wyz@0.5.1
	zerocopy-derive@0.7.34
	zerocopy@0.7.34
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Core validation logic for pydantic written in Rust"
HOMEPAGE="
	https://github.com/pydantic/pydantic-core/
	https://pypi.org/project/pydantic-core/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~loong ppc ~ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-python/typing-extensions-4.7.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=virtual/rust-1.70.0
	test? (
		>=dev-python/dirty-equals-0.5.0[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-6.63.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-3.10.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-timeout-2.1.0[${PYTHON_USEDEP}]
		>=dev-python/pydantic-1.10.4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/pydantic_core/_pydantic_core.*.so"

src_prepare() {
	sed -i -e '/--benchmark/d' pyproject.toml || die
	sed -i -e '/^strip/d' Cargo.toml || die
	distutils-r1_src_prepare
}

python_test() {
	local EPYTEST_IGNORE=(
		tests/benchmarks
	)
	local EPYTEST_DESELECT=(
		# TODO: recursion till segfault
		tests/serializers/test_functions.py::test_recursive_call
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	rm -rf pydantic_core || die
	# tests link to libpython, so they fail to link on pypy3
	[[ ${EPYTHON} != pypy3 ]] && cargo_src_test
	epytest -p pytest_mock -p timeout
}
