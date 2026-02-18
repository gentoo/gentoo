# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1

CRATES="
	allocator-api2@0.2.21
	autocfg@1.5.0
	equivalent@1.0.2
	foldhash@0.2.0
	hashbrown@0.16.0
	heck@0.5.0
	indoc@2.0.7
	itoa@1.0.15
	libc@0.2.177
	memchr@2.7.6
	memmap2@0.9.9
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.103
	pyo3-build-config@0.25.1
	pyo3-ffi@0.25.1
	pyo3-macros-backend@0.25.1
	pyo3-macros@0.25.1
	pyo3@0.25.1
	quote@1.0.42
	rustversion@1.0.22
	ryu@1.0.20
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	syn@2.0.110
	target-lexicon@0.13.3
	unicode-ident@1.0.22
	unindent@0.2.4
"

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..14} )
RUST_MIN_VER="1.80"

inherit distutils-r1 cargo

DESCRIPTION="Simple, safe way to store and distribute tensors"
HOMEPAGE="
	https://pypi.org/project/safetensors/
	https://huggingface.co/
"
SRC_URI="https://github.com/huggingface/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

S="${WORKDIR}"/${P}/bindings/python

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_FLAGS_IGNORED="usr/lib/.*"
RESTRICT="test" #depends on single pkg ( pytorch )

BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		dev-python/h5py[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	rm tests/test_{tf,paddle,flax}_comparison.py || die
	rm benches/test_{pt,tf,paddle,flax}.py || die
}

src_configure() {
	cargo_src_configure
	distutils-r1_src_configure
}

python_compile() {
	cargo_src_compile
	distutils-r1_python_compile
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}
