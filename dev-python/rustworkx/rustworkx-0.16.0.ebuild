# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

CRATES="
	adler2@2.0.0
	ahash@0.8.11
	allocator-api2@0.2.21
	autocfg@1.4.0
	byteorder@1.5.0
	cfg-if@1.0.0
	crc32fast@1.4.2
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	either@1.13.0
	equivalent@1.0.1
	fixedbitset@0.5.7
	flate2@1.0.35
	foldhash@0.1.4
	getrandom@0.2.15
	hashbrown@0.15.2
	heck@0.5.0
	hermit-abi@0.3.9
	indexmap@2.7.0
	indoc@2.0.5
	itertools@0.11.0
	itertools@0.13.0
	itoa@1.0.14
	libc@0.2.169
	matrixmultiply@0.3.9
	memchr@2.7.4
	memoffset@0.9.1
	miniz_oxide@0.8.3
	ndarray-stats@0.6.0
	ndarray@0.16.1
	noisy_float@0.2.0
	num-bigint@0.4.6
	num-complex@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	num_cpus@1.16.0
	numpy@0.23.0
	once_cell@1.20.2
	petgraph@0.7.1
	portable-atomic-util@0.2.4
	portable-atomic@1.10.0
	ppv-lite86@0.2.20
	priority-queue@2.1.1
	proc-macro2@1.0.93
	pyo3-build-config@0.23.4
	pyo3-ffi@0.23.4
	pyo3-macros-backend@0.23.4
	pyo3-macros@0.23.4
	pyo3@0.23.4
	quick-xml@0.37.2
	quote@1.0.38
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_pcg@0.3.1
	rawpointer@0.2.1
	rayon-cond@0.3.0
	rayon-core@1.12.1
	rayon@1.10.0
	rustc-hash@2.1.0
	ryu@1.0.18
	serde@1.0.217
	serde_derive@1.0.217
	serde_json@1.0.135
	smallvec@1.13.2
	sprs@0.11.2
	syn@2.0.96
	target-lexicon@0.12.16
	unicode-ident@1.0.14
	unindent@0.2.3
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo distutils-r1

DESCRIPTION="A high performance Python graph library implemented in Rust"
HOMEPAGE="
	https://github.com/Qiskit/rustworkx/
	https://pypi.org/project/rustworkx/
"
SRC_URI="
	https://github.com/Qiskit/rustworkx/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 MIT Unicode-3.0
	ZLIB
	|| ( LGPL-3+ MPL-2.0 )
"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.16.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
		dev-python/fixtures[${PYTHON_USEDEP}]
		dev-python/graphviz[${PYTHON_USEDEP}]
		>=dev-python/networkx-2.5[${PYTHON_USEDEP}]
		dev-python/stestr[${PYTHON_USEDEP}]
		>=dev-python/testtools-2.5.0[${PYTHON_USEDEP}]
		media-gfx/graphviz[gts]
	)
"

# Libraries built with rust do not use CFLAGS and LDFLAGS.
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/rustworkx/rustworkx.*\\.so"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	local EPYTEST_DESELECT=(
		# TODO: hangs
		tests/retworkx_backwards_compat/visualization/test_mpl.py
		tests/rustworkx_tests/visualization/test_mpl.py
	)
	rm -rf rustworkx || die
	epytest
}
