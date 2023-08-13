# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1

CRATES="
	autocfg-1.1.0
	bitflags-1.3.2
	cfg-if-1.0.0
	indoc-1.0.9
	itoa-1.0.6
	libc-0.2.141
	lock_api-0.4.9
	memmap2-0.5.10
	memoffset-0.8.0
	once_cell-1.17.1
	parking_lot-0.12.1
	parking_lot_core-0.9.7
	proc-macro2-1.0.56
	pyo3-0.18.2
	pyo3-build-config-0.18.2
	pyo3-ffi-0.18.2
	pyo3-macros-0.18.2
	pyo3-macros-backend-0.18.2
	quote-1.0.26
	redox_syscall-0.2.16
	ryu-1.0.13
	scopeguard-1.1.0
	serde-1.0.160
	serde_derive-1.0.160
	serde_json-1.0.95
	smallvec-1.10.0
	syn-1.0.109
	syn-2.0.14
	target-lexicon-0.12.6
	unicode-ident-1.0.8
	unindent-0.1.11
	windows-sys-0.45.0
	windows-targets-0.42.2
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_msvc-0.42.2
	windows_i686_gnu-0.42.2
	windows_i686_msvc-0.42.2
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_msvc-0.42.2
"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 cargo

DESCRIPTION="Simple, safe way to store and distribute tensors"
HOMEPAGE="
	https://pypi.org/project/safetensors/
	https://huggingface.co/
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
	$(cargo_crate_uris)"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/lib/.*"
RESTRICT="test" #depends on single pkg ( pytorch )

RDEPEND="
"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

S="${WORKDIR}"/${P}/bindings/python

src_prepare() {
	distutils-r1_src_prepare
	rm tests/test_{tf,paddle,flax}_comparison.py || die
	rm benches/test_{pt,tf,paddle,flax}.py || die
}

src_configure() {
	cargo_src_configure
	distutils-r1_src_configure
}

src_compile() {
	cargo_src_compile
	distutils-r1_src_compile
}

src_test() {
	cargo_src_test
	distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install
}
