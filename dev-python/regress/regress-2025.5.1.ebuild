# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

CRATES="
	allocator-api2@0.2.18
	autocfg@1.1.0
	cc@1.1.7
	equivalent@1.0.1
	foldhash@0.1.4
	hashbrown@0.15.2
	heck@0.5.0
	indoc@2.0.4
	libc@0.2.155
	memchr@2.5.0
	memoffset@0.9.0
	once_cell@1.19.0
	portable-atomic@1.6.0
	proc-macro2@1.0.86
	pyo3-build-config@0.25.0
	pyo3-ffi@0.25.0
	pyo3-macros-backend@0.25.0
	pyo3-macros@0.25.0
	pyo3@0.25.0
	python3-dll-a@0.2.12
	quote@1.0.36
	regress@0.10.3
	syn@2.0.72
	target-lexicon@0.13.2
	unicode-ident@1.0.8
	unindent@0.2.3
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
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~riscv"

distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/regress/regress.*.so"
