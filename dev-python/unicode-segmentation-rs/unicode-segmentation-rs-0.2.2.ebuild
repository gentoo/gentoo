# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

RUST_MIN_VER="1.85.0"
CRATES="
	cc@1.2.57
	find-msvc-tools@0.1.9
	heck@0.5.0
	libc@0.2.183
	once_cell@1.21.4
	portable-atomic@1.13.1
	proc-macro2@1.0.106
	pyo3-build-config@0.28.2
	pyo3-ffi@0.28.2
	pyo3-macros-backend@0.28.2
	pyo3-macros@0.28.2
	pyo3@0.28.2
	python3-dll-a@0.2.14
	quote@1.0.45
	shlex@1.3.0
	syn@2.0.117
	target-lexicon@0.13.5
	unicode-ident@1.0.24
	unicode-segmentation@1.13.2
	unicode-width@0.2.2
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Unicode segmentation and width for Python using Rust"
HOMEPAGE="
	https://github.com/WeblateOrg/unicode-segmentation-rs/
	https://pypi.org/project/unicode-segmentation-rs/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="amd64 arm64"

QA_FLAGS_IGNORED="
	usr/lib/py.*/site-packages/unicode_segmentation_rs/unicode_segmentation_rs.*
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
