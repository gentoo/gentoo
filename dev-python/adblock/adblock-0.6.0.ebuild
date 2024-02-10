# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adblock@0.5.6
	addr@0.14.0
	adler@1.0.2
	aho-corasick@0.7.18
	autocfg@1.1.0
	base64@0.13.0
	bitflags@1.3.2
	byteorder@1.4.3
	cfg-if@1.0.0
	crc32fast@1.3.2
	either@1.7.0
	flate2@1.0.24
	form_urlencoded@1.0.1
	idna@0.2.3
	indoc@1.0.6
	itertools@0.10.3
	libc@0.2.126
	lock_api@0.4.7
	matches@0.1.9
	memchr@2.5.0
	miniz_oxide@0.5.3
	num-traits@0.2.15
	once_cell@1.13.0
	parking_lot@0.12.1
	parking_lot_core@0.9.3
	paste@1.0.7
	percent-encoding@2.1.0
	proc-macro2@1.0.40
	psl-types@2.0.10
	psl@2.0.90
	pyo3-build-config@0.16.5
	pyo3-ffi@0.16.5
	pyo3-macros-backend@0.16.5
	pyo3-macros@0.16.5
	pyo3@0.16.5
	quote@1.0.20
	redox_syscall@0.2.13
	regex-syntax@0.6.27
	regex@1.6.0
	rmp-serde@0.13.7
	rmp-serde@0.15.5
	rmp@0.8.11
	scopeguard@1.1.0
	seahash@3.0.7
	serde@1.0.139
	serde_derive@1.0.139
	smallvec@1.9.0
	syn@1.0.98
	target-lexicon@0.12.4
	tinyvec@1.6.0
	tinyvec_macros@0.1.0
	twoway@0.2.2
	unchecked-index@0.2.2
	unicode-bidi@0.3.8
	unicode-ident@1.0.2
	unicode-normalization@0.1.21
	unindent@0.1.9
	url@2.2.2
	windows-sys@0.36.1
	windows_aarch64_msvc@0.36.1
	windows_i686_gnu@0.36.1
	windows_i686_msvc@0.36.1
	windows_x86_64_gnu@0.36.1
	windows_x86_64_msvc@0.36.1
"
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..12} )
inherit cargo distutils-r1

DESCRIPTION="Python wrapper for Brave's adblocking library, which is written in Rust"
HOMEPAGE="https://github.com/ArniDagur/python-adblock"
SRC_URI="
	https://github.com/ArniDagur/python-adblock/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/python-${P}"

LICENSE="|| ( MIT Apache-2.0 )"
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT MPL-2.0
	Unicode-DFS-2016
" # crates
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

distutils_enable_tests pytest

QA_FLAGS_IGNORED=".*/adblock.*.so"

DOCS=( CHANGELOG.md README.md )

PATCHES=(
	"${FILESDIR}"/${P}-maturin-0.14.13.patch
)

python_test() {
	local EPYTEST_DESELECT=(
		# unimportant (for us) test that uses the dir that we delete below
		# so pytest does not try to load it while lacking extensions
		tests/test_typestubs.py::test_functions_and_methods_exist_in_rust
	)
	local EPYTEST_IGNORE=(
		# not very meaningful here (e.g. validates changelog),
		# and needs the deprecated dev-python/toml
		tests/test_metadata.py
	)

	rm -rf adblock || die
	epytest
}
