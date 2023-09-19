# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
# pypy3 is waiting for new pyo3 release
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	ahash@0.8.3
	aho-corasick@1.0.2
	autocfg@1.1.0
	base64@0.21.3
	bitflags@1.3.2
	cc@1.0.79
	cfg-if@1.0.0
	enum_dispatch@0.3.12
	equivalent@1.0.1
	form_urlencoded@1.2.0
	getrandom@0.2.10
	hashbrown@0.14.0
	heck@0.4.1
	idna@0.4.0
	indexmap@2.0.0
	indoc@1.0.9
	itoa@1.0.8
	libc@0.2.147
	lock_api@0.4.10
	memchr@2.5.0
	memoffset@0.9.0
	num-bigint@0.4.4
	num-integer@0.1.45
	num-traits@0.2.16
	once_cell@1.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	percent-encoding@2.3.0
	proc-macro2@1.0.64
	pyo3-build-config@0.19.2
	pyo3-ffi@0.19.2
	pyo3-macros-backend@0.19.2
	pyo3-macros@0.19.2
	pyo3@0.19.2
	python3-dll-a@0.2.9
	quote@1.0.29
	redox_syscall@0.3.5
	regex-automata@0.3.7
	regex-syntax@0.7.5
	regex@1.9.4
	rustversion@1.0.13
	ryu@1.0.14
	scopeguard@1.1.0
	serde@1.0.188
	serde_derive@1.0.188
	serde_json@1.0.105
	smallvec@1.11.0
	speedate@0.12.0
	strum@0.25.0
	strum_macros@0.25.2
	syn@1.0.109
	syn@2.0.28
	target-lexicon@0.12.9
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	unicode-bidi@0.3.13
	unicode-ident@1.0.10
	unicode-normalization@0.1.22
	unindent@0.1.11
	url@2.4.1
	uuid@1.4.1
	version_check@0.9.4
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
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

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
		>=dev-python/pytz-2022.7.1[${PYTHON_USEDEP}]
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

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	rm -rf pydantic_core || die
	epytest -p pytest_mock -p timeout
}
