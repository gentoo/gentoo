# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/breezy-team/patiencediff
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

CRATES="
	autocfg@1.5.0
	heck@0.5.0
	indoc@2.0.6
	libc@0.2.177
	memoffset@0.9.1
	once_cell@1.21.3
	patiencediff@0.2.1
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	pyo3-build-config@0.26.0
	pyo3-ffi@0.26.0
	pyo3-macros-backend@0.26.0
	pyo3-macros@0.26.0
	pyo3@0.26.0
	quote@1.0.41
	syn@2.0.106
	target-lexicon@0.13.3
	unicode-ident@1.0.19
	unindent@0.2.4
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Python implementation of the patiencediff algorithm"
HOMEPAGE="
	https://github.com/breezy-team/patiencediff/
	https://pypi.org/project/patiencediff/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-2+"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions GPL-2+ MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/patiencediff/_patiencediff_rs.*.so"

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}

src_configure() {
	# makes extension builds fatal
	export CIBUILDWHEEL=1
}

python_test() {
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	eunittest
}
