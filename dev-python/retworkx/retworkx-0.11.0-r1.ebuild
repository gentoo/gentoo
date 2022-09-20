# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

# Generated with https://github.com/gentoo/cargo-ebuild.
CRATES="
	ahash-0.7.6
	autocfg-1.0.1
	bitflags-1.3.2
	cfg-if-0.1.10
	cfg-if-1.0.0
	crossbeam-channel-0.5.1
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.5
	crossbeam-utils-0.8.5
	either-1.6.1
	fixedbitset-0.4.1
	getrandom-0.2.3
	hashbrown-0.11.2
	hermit-abi-0.1.19
	indexmap-1.7.0
	indoc-0.3.6
	indoc-impl-0.3.6
	instant-0.1.10
	lazy_static-1.4.0
	libc-0.2.101
	lock_api-0.4.5
	matrixmultiply-0.2.4
	memoffset-0.6.4
	ndarray-0.13.1
	num-bigint-0.4.3
	num-complex-0.2.4
	num-complex-0.4.0
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.0
	numpy-0.15.1
	once_cell-1.8.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	paste-0.1.18
	paste-impl-0.1.18
	petgraph-0.6.0
	ppv-lite86-0.2.10
	proc-macro-hack-0.5.19
	proc-macro2-1.0.29
	pyo3-0.15.1
	pyo3-build-config-0.15.1
	pyo3-macros-0.15.1
	pyo3-macros-backend-0.15.1
	quote-1.0.9
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_hc-0.3.1
	rand_pcg-0.3.1
	rawpointer-0.2.1
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.10
	scopeguard-1.1.0
	smallvec-1.6.1
	syn-1.0.76
	unicode-xid-0.2.2
	unindent-0.1.7
	version_check-0.9.3
	wasi-0.10.2+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo distutils-r1

DESCRIPTION="A high performance Python graph library implemented in Rust"
HOMEPAGE="https://github.com/Qiskit/retworkx"
SRC_URI="https://github.com/Qiskit/retworkx/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/graphviz[${PYTHON_USEDEP}]
		>=dev-python/networkx-2.5[${PYTHON_USEDEP}]
		dev-python/stestr[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.5.0[${PYTHON_USEDEP}]
		media-gfx/graphviz[gts]
	)"

RDEPEND=">=dev-python/numpy-1.16.0[${PYTHON_USEDEP}]"

# Libraries built with rust do not use CFLAGS and LDFLAGS.
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/retworkx/retworkx.*\\.so"

distutils_enable_tests pytest

python_test() {
	# We have to hide the source code directory so tests
	# do not use these, but instead the compiled library.
	mv retworkx retworkx.hidden || die
	# There is one small test which has issues, skipping it.
	epytest -k 'not test_image_type'
	mv retworkx.hidden retworkx || die
}
