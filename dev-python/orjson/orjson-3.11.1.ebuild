# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} )

# upstream is vendoring crates
CRATES="
	associative-cache@2.0.0
	bytecount@0.6.9
	bytes@1.10.1
	cc@1.2.29
	cfg-if@1.0.1
	crunchy@0.2.4
	encoding_rs@0.8.35
	gimli@0.31.1
	half@2.6.0
	itoa@1.0.15
	itoap@1.0.1
	jiff-static@0.2.15
	jiff@0.2.15
	libc@0.2.174
	memchr@2.7.5
	once_cell@1.21.3
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	proc-macro2@1.0.95
	pyo3-build-config@0.25.1
	pyo3-ffi@0.25.1
	quote@1.0.40
	ryu@1.0.20
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.140
	shlex@1.3.0
	simdutf8@0.1.5
	smallvec@1.15.1
	syn@2.0.104
	target-lexicon@0.13.2
	unicode-ident@1.0.18
	unwinding@0.2.5
	uuid@1.17.0
	version_check@0.9.5
	xxhash-rust@0.8.15
"

RUST_MIN_VER="1.74.1"

inherit cargo distutils-r1 pypi

DESCRIPTION="Fast, correct Python JSON library supporting dataclasses, datetimes, and numpy"
HOMEPAGE="
	https://github.com/ijl/orjson/
	https://pypi.org/project/orjson/
"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	>=dev-util/maturin-1.7.8[${PYTHON_USEDEP}]
	test? (
		dev-python/arrow[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

QA_FLAGS_IGNORED=".*"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
