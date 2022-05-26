# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adblock-0.4.3
	addr-0.14.0
	adler-1.0.2
	aho-corasick-0.7.18
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	byteorder-1.4.3
	cfg-if-1.0.0
	crc32fast-1.3.2
	either-1.6.1
	flate2-1.0.22
	form_urlencoded-1.0.1
	idna-0.2.3
	indoc-0.3.6
	indoc-impl-0.3.6
	instant-0.1.12
	itertools-0.10.3
	libc-0.2.118
	lock_api-0.4.6
	matches-0.1.9
	memchr-2.4.1
	miniz_oxide-0.4.4
	num-traits-0.2.14
	once_cell-1.9.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	paste-0.1.18
	paste-impl-0.1.18
	percent-encoding-2.1.0
	proc-macro-hack-0.5.19
	proc-macro2-1.0.36
	psl-2.0.71
	psl-types-2.0.10
	pyo3-0.15.1
	pyo3-build-config-0.15.1
	pyo3-macros-0.15.1
	pyo3-macros-backend-0.15.1
	quote-1.0.15
	redox_syscall-0.2.10
	regex-1.5.4
	regex-syntax-0.6.25
	rmp-0.8.10
	rmp-serde-0.13.7
	rmp-serde-0.15.5
	scopeguard-1.1.0
	seahash-3.0.7
	serde-1.0.136
	serde_derive-1.0.136
	smallvec-1.8.0
	syn-1.0.86
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	twoway-0.2.2
	unchecked-index-0.2.2
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-xid-0.2.2
	unindent-0.1.7
	url-2.2.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0"
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{8..11} )
inherit cargo distutils-r1

DESCRIPTION="Python wrapper for Brave's adblocking library, which is written in Rust"
HOMEPAGE="https://github.com/ArniDagur/python-adblock"
SRC_URI="
	https://github.com/ArniDagur/python-adblock/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"
S="${WORKDIR}/python-${P}"

LICENSE="Apache-2.0 BSD MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

BDEPEND="test? ( dev-python/toml[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

QA_FLAGS_IGNORED=".*/adblock.*.so"

DOCS=( CHANGELOG.md README.md )

src_compile() {
	distutils-r1_src_compile

	# tests try to find Cargo.toml + adblock/adblock.pyi in current
	# directory but will fail if pytest finds init in ./adblock
	rm adblock/__init__.py || die
}
