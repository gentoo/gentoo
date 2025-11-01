# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

RUST_MIN_VER="1.85.0"
CRATES="
	allocator-api2@0.2.21
	autocfg@1.5.0
	cc@1.2.35
	equivalent@1.0.2
	find-msvc-tools@0.1.0
	foldhash@0.1.5
	hashbrown@0.15.5
	heck@0.5.0
	indoc@2.0.6
	libc@0.2.175
	memchr@2.7.5
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	pyo3-build-config@0.26.0
	pyo3-ffi@0.26.0
	pyo3-macros-backend@0.26.0
	pyo3-macros@0.26.0
	pyo3@0.26.0
	python3-dll-a@0.2.14
	quote@1.0.40
	regress@0.10.4
	shlex@1.3.0
	syn@2.0.106
	target-lexicon@0.13.2
	unicode-ident@1.0.18
	unindent@0.2.4
"

inherit cargo distutils-r1

DESCRIPTION="Python bindings to the Rust regress crate"
HOMEPAGE="
	https://pypi.org/project/regress/
	https://github.com/crate-py/regress
"
SRC_URI="
	https://github.com/crate-py/regress/releases/download/v${PV}/${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/regress/regress.*.so"
