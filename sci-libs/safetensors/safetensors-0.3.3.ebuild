# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1

CRATES="
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	indoc@1.0.9
	itoa@1.0.9
	libc@0.2.147
	lock_api@0.4.10
	memmap2@0.5.10
	memoffset@0.8.0
	once_cell@1.18.0
	parking_lot@0.12.1
	parking_lot_core@0.9.8
	proc-macro2@1.0.66
	pyo3-build-config@0.18.3
	pyo3-ffi@0.18.3
	pyo3-macros-backend@0.18.3
	pyo3-macros@0.18.3
	pyo3@0.18.3
	quote@1.0.33
	redox_syscall@0.3.5
	ryu@1.0.15
	scopeguard@1.2.0
	serde@1.0.185
	serde_derive@1.0.185
	serde_json@1.0.105
	smallvec@1.11.0
	syn@1.0.109
	syn@2.0.29
	target-lexicon@0.12.11
	unicode-ident@1.0.11
	unindent@0.1.11
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

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

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/lib/.*"
RESTRICT="test" #depends on single pkg ( pytorch )

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
