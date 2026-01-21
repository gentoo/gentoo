# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	autocfg@1.5.0
	heck@0.5.0
	indoc@2.0.7
	libc@0.2.180
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.13.0
	proc-macro2@1.0.105
	pyo3-build-config@0.27.2
	pyo3-ffi@0.27.2
	pyo3-macros-backend@0.27.2
	pyo3-macros@0.27.2
	pyo3@0.27.2
	quote@1.0.43
	rustversion@1.0.22
	syn@2.0.114
	target-lexicon@0.13.4
	unicode-ident@1.0.22
	unindent@0.2.4
"

CARGO_OPTIONAL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/breezy-team/fastbencode
PYTHON_COMPAT=( python3_{11..14} )

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
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
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
