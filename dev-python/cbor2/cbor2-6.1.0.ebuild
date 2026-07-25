# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/agronholm/cbor2
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

RUST_MIN_VER="1.85.0"
CRATES="
	autocfg@1.5.0
	bigdecimal@0.4.10
	cfg-if@1.0.4
	crunchy@0.2.4
	half@2.7.1
	heck@0.5.0
	libc@0.2.182
	libm@0.2.16
	num-bigint@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	once_cell@1.21.3
	portable-atomic@1.13.1
	proc-macro2@1.0.106
	pyo3-build-config@0.28.2
	pyo3-ffi@0.28.2
	pyo3-macros-backend@0.28.2
	pyo3-macros@0.28.2
	pyo3@0.28.2
	quote@1.0.44
	syn@2.0.117
	target-lexicon@0.13.5
	unicode-ident@1.0.24
	zerocopy-derive@0.8.40
	zerocopy@0.8.40
"

inherit cargo distutils-r1 pypi

DESCRIPTION="CBOR (de)serializer with extensive tag support"
HOMEPAGE="
	https://github.com/agronholm/cbor2/
	https://pypi.org/project/cbor2/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	>=dev-python/setuptools-61[${PYTHON_USEDEP}]
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.4[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( hypothesis )
distutils_enable_tests pytest

# Files built without CFLAGS/LDFLAGS, acceptable for rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/cbor2/_cbor2.*.so"

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}
