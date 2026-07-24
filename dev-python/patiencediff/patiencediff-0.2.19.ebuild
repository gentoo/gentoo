# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/breezy-team/patiencediff
PYTHON_COMPAT=( python3_{12..15} )

RUST_MIN_VER="1.83.0"
CRATES="
	heck@0.5.0
	libc@0.2.186
	once_cell@1.21.4
	patiencediff@0.2.1
	portable-atomic@1.13.1
	proc-macro2@1.0.106
	pyo3-build-config@0.29.0
	pyo3-ffi@0.29.0
	pyo3-macros-backend@0.29.0
	pyo3-macros@0.29.0
	pyo3@0.29.0
	quote@1.0.45
	syn@2.0.117
	target-lexicon@0.13.5
	unicode-ident@1.0.24
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
LICENSE+="
	Apache-2.0-with-LLVM-exceptions GPL-2+ Unicode-3.0
	|| ( Apache-2.0 MIT )
"
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
