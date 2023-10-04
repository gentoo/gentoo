# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

CRATES="
	ahash@0.7.6
	ahash@0.8.0
	alga@0.9.3
	approx@0.3.2
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	crossbeam-channel@0.5.6
	crossbeam-deque@0.8.2
	crossbeam-epoch@0.9.11
	crossbeam-utils@0.8.12
	either@1.8.0
	fixedbitset@0.4.2
	getrandom@0.2.8
	hashbrown@0.12.3
	hermit-abi@0.1.19
	indexmap@1.9.3
	indoc@1.0.7
	itertools@0.10.5
	itoa@1.0.4
	libc@0.2.137
	libm@0.2.7
	lock_api@0.4.9
	matrixmultiply@0.3.2
	memchr@2.5.0
	memoffset@0.6.5
	memoffset@0.9.0
	ndarray-stats@0.5.1
	ndarray@0.15.6
	noisy_float@0.2.0
	num-bigint@0.4.3
	num-complex@0.2.4
	num-complex@0.4.3
	num-integer@0.1.45
	num-traits@0.2.16
	num_cpus@1.13.1
	numpy@0.19.0
	once_cell@1.15.0
	parking_lot@0.12.1
	parking_lot_core@0.9.4
	petgraph@0.6.3
	ppv-lite86@0.2.16
	priority-queue@1.2.2
	proc-macro2@1.0.52
	pyo3-build-config@0.19.2
	pyo3-ffi@0.19.2
	pyo3-macros-backend@0.19.2
	pyo3-macros@0.19.2
	pyo3@0.19.2
	quick-xml@0.28.2
	quote@1.0.26
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_pcg@0.3.1
	rawpointer@0.2.1
	rayon-cond@0.2.0
	rayon-core@1.10.1
	rayon@1.6.1
	redox_syscall@0.2.16
	rustc-hash@1.1.0
	ryu@1.0.11
	scopeguard@1.1.0
	serde@1.0.163
	serde_derive@1.0.163
	serde_json@1.0.96
	smallvec@1.10.0
	sprs@0.11.0
	syn@1.0.104
	syn@2.0.3
	target-lexicon@0.12.4
	unicode-ident@1.0.5
	unindent@0.1.10
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-sys@0.42.0
	windows_aarch64_gnullvm@0.42.0
	windows_aarch64_msvc@0.42.0
	windows_i686_gnu@0.42.0
	windows_i686_msvc@0.42.0
	windows_x86_64_gnu@0.42.0
	windows_x86_64_gnullvm@0.42.0
	windows_x86_64_msvc@0.42.0
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
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 MIT
	Unicode-DFS-2016
	|| ( LGPL-3 MPL-2.0 )
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
