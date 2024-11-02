# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..13} )

CRATES="
	associative-cache@2.0.0
	bytecount@0.6.8
	castaway@0.2.3
	cc@1.1.31
	cfg-if@1.0.0
	compact_str@0.8.0
	crunchy@0.2.2
	encoding_rs@0.8.35
	gimli@0.30.0
	half@2.4.1
	itoa@1.0.11
	itoap@1.0.1
	jiff@0.1.14
	libc@0.2.161
	memchr@2.7.4
	no-panic@0.1.30
	once_cell@1.20.2
	proc-macro2@1.0.89
	quote@1.0.37
	rustversion@1.0.18
	ryu@1.0.18
	serde@1.0.214
	serde_derive@1.0.214
	serde_json@1.0.132
	shlex@1.3.0
	simdutf8@0.1.5
	smallvec@1.13.2
	static_assertions@1.1.0
	syn@2.0.86
	target-lexicon@0.12.16
	unicode-ident@1.0.13
	unwinding@0.2.2
	uuid@1.11.0
	version_check@0.9.5
	xxhash-rust@0.8.12
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
	Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	>=virtual/rust-1.72
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

export UNSAFE_PYO3_SKIP_VERSION_CHECK=1

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
