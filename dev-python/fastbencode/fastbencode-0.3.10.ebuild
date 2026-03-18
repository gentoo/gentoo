# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
RUST_MIN_VER=1.83.0

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/breezy-team/fastbencode
PYTHON_COMPAT=( python3_{11..14} )

CRATES="
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
	quote@1.0.45
	syn@2.0.117
	target-lexicon@0.13.5
	unicode-ident@1.0.24
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Implementation of bencode with Rust implementation"
HOMEPAGE="
	https://github.com/breezy-team/fastbencode/
	https://pypi.org/project/fastbencode/
"
SRC_URI+="
	native-extensions? (
		${CARGO_CRATE_URIS}
	)
"

LICENSE="Apache-2.0"
LICENSE+=" native-extensions? ("
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions Unicode-3.0
	|| ( Apache-2.0 MIT )
"
LICENSE+=" )"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+native-extensions"

BDEPEND="
	native-extensions? (
		${RUST_DEPEND}
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/fastbencode/_bencode_rs.*.so"

pkg_setup() {
	use native-extensions && rust_pkg_setup
}

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}

src_prepare() {
	distutils-r1_src_prepare

	# treat build failures as fatal
	sed -i -e '/optional/d' setup.py || die

	if ! use native-extensions; then
		# setup.py is only used for setuptools-rust
		rm setup.py || die
	fi
}

src_test() {
	rm -r fastbencode || die
	distutils-r1_src_test
}
