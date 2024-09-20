# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..13} )

CRATES="
	ahash@0.8.11
	allocator-api2@0.2.18
	autocfg@1.1.0
	cc@1.1.7
	cfg-if@1.0.0
	hashbrown@0.14.5
	heck@0.5.0
	indoc@2.0.4
	libc@0.2.140
	memchr@2.5.0
	memoffset@0.9.0
	once_cell@1.19.0
	portable-atomic@1.6.0
	proc-macro2@1.0.86
	pyo3-build-config@0.22.2
	pyo3-ffi@0.22.2
	pyo3-macros-backend@0.22.2
	pyo3-macros@0.22.2
	pyo3@0.22.2
	python3-dll-a@0.2.10
	quote@1.0.36
	regress@0.10.0
	syn@2.0.72
	target-lexicon@0.12.16
	unicode-ident@1.0.8
	unindent@0.2.3
	version_check@0.9.4
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
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
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv"

distutils_enable_tests pytest

QA_FLAGS_IGNORED="usr/lib/py.*/site-packages/regress/regress.*.so"
