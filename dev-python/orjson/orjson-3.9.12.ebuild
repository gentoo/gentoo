# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..12} )

CRATES="
	ahash@0.8.6
	arrayvec@0.7.4
	associative-cache@2.0.0
	autocfg@1.1.0
	beef@0.5.2
	bytecount@0.6.7
	castaway@0.2.2
	cc@1.0.83
	cfg-if@1.0.0
	chrono@0.4.31
	compact_str@0.7.1
	const-random-macro@0.1.16
	const-random@0.1.17
	crunchy@0.2.2
	encoding_rs@0.8.33
	getrandom@0.2.12
	itoa@1.0.10
	itoap@1.0.1
	libc@0.2.152
	no-panic@0.1.28
	num-traits@0.2.17
	once_cell@1.19.0
	proc-macro2@1.0.76
	pyo3-build-config@0.20.2
	pyo3-ffi@0.20.2
	quote@1.0.35
	rustversion@1.0.14
	ryu@1.0.16
	serde@1.0.195
	serde_derive@1.0.195
	serde_json@1.0.111
	simdutf8@0.1.4
	smallvec@1.12.0
	static_assertions@1.1.0
	syn@2.0.48
	target-lexicon@0.12.13
	tiny-keccak@2.0.2
	unicode-ident@1.0.12
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy"
HOMEPAGE="
	https://github.com/ijl/orjson/
	https://pypi.org/project/orjson/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions BSD CC0-1.0 MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	test? (
		dev-python/arrow[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		' 'python3*')
	)
"

QA_FLAGS_IGNORED=".*"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -s
}
