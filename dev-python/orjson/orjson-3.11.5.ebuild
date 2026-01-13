# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYPI_VERIFY_REPO=https://github.com/ijl/orjson
PYTHON_COMPAT=( python3_{11..14} )

# upstream is vendoring crates
CRATES="
	associative-cache@2.0.0
	bytecount@0.6.9
	bytes@1.11.0
	cc@1.2.48
	cfg-if@1.0.4
	crunchy@0.2.4
	encoding_rs@0.8.35
	find-msvc-tools@0.1.5
	gimli@0.32.3
	half@2.7.1
	itoa@1.0.15
	itoap@1.0.1
	jiff-static@0.2.16
	jiff@0.2.16
	libc@0.2.178
	memchr@2.7.6
	once_cell@1.21.3
	portable-atomic-util@0.2.4
	portable-atomic@1.11.1
	proc-macro2@1.0.103
	pyo3-build-config@0.27.2
	pyo3-ffi@0.27.2
	quote@1.0.42
	ryu@1.0.20
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	shlex@1.3.0
	simdutf8@0.1.5
	smallvec@1.15.1
	syn@2.0.111
	target-lexicon@0.13.3
	unicode-ident@1.0.22
	unwinding@0.2.8
	uuid@1.19.0
	version_check@0.9.5
	xxhash-rust@0.8.15
	zerocopy-derive@0.8.31
	zerocopy@0.8.31
"
RUST_MIN_VER="1.88.0"

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
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

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

src_unpack() {
	pypi_src_unpack

	# https://github.com/ijl/orjson/issues/613
	cargo_gen_config
}
