# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash-0.7.6
	autocfg-1.1.0
	bitflags-1.3.2
	cfg-if-1.0.0
	crossbeam-channel-0.5.4
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.8
	crossbeam-utils-0.8.8
	either-1.6.1
	fixedbitset-0.4.2
	getrandom-0.2.6
	hashbrown-0.11.2
	hermit-abi-0.1.19
	indexmap-1.7.0
	indoc-1.0.6
	instant-0.1.12
	itoa-1.0.2
	lazy_static-1.4.0
	libc-0.2.126
	lock_api-0.4.7
	matrixmultiply-0.2.4
	memchr-2.5.0
	memoffset-0.6.5
	ndarray-0.13.1
	num-bigint-0.4.3
	num-complex-0.2.4
	num-complex-0.4.1
	num_cpus-1.13.1
	num-integer-0.1.45
	numpy-0.16.2
	num-traits-0.2.15
	once_cell-1.12.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	petgraph-0.6.2
	ppv-lite86-0.2.16
	priority-queue-1.2.0
	proc-macro2-1.0.39
	pyo3-0.16.6
	pyo3-build-config-0.16.6
	pyo3-ffi-0.16.6
	pyo3-macros-0.16.6
	pyo3-macros-backend-0.16.6
	quick-xml-0.22.0
	quote-1.0.18
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_pcg-0.3.1
	rawpointer-0.2.1
	rayon-1.5.3
	rayon-core-1.9.3
	redox_syscall-0.2.13
	ryu-1.0.10
	scopeguard-1.1.0
	serde-1.0.145
	serde_derive-1.0.145
	serde_json-1.0.85
	smallvec-1.8.0
	syn-1.0.96
	target-lexicon-0.12.4
	unicode-ident-1.0.0
	unindent-0.1.9
	version_check-0.9.4
	wasi-0.10.2+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit cargo distutils-r1

DESCRIPTION="A high performance Python graph library implemented in Rust"
HOMEPAGE="https://github.com/Qiskit/rustworkx"
SRC_URI="https://github.com/Qiskit/rustworkx/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
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
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/rustworkx/rustworkx.*\\.so"

distutils_enable_tests pytest

python_test() {
	# We have to hide the source code directory so tests
	# do not use these, but instead the compiled library.
	mv rustworkx rustworkx.hidden || die
	# There is one small test which has issues, skipping it.
	epytest -k 'not test_image_type'
	mv rustworkx.hidden rustworkx || die
}
