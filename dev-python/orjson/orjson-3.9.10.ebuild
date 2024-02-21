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
	encoding_rs@0.8.33
	itoa@1.0.9
	itoap@1.0.1
	libc@0.2.149
	libm@0.2.8
	no-panic@0.1.26
	num-traits@0.2.17
	once_cell@1.18.0
	packed_simd@0.3.9
	proc-macro2@1.0.69
	pyo3-build-config@0.20.0
	pyo3-ffi@0.20.0
	quote@1.0.33
	rustversion@1.0.14
	ryu@1.0.15
	serde@1.0.190
	serde_derive@1.0.190
	serde_json@1.0.107
	simdutf8@0.1.4
	smallvec@1.11.1
	static_assertions@1.1.0
	syn@2.0.38
	target-lexicon@0.12.12
	unicode-ident@1.0.12
	version_check@0.9.4
	zerocopy-derive@0.7.15
	zerocopy@0.7.15
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
	Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"

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
