# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

CRATES="
	ahash@0.8.11
	alga@0.9.3
	allocator-api2@0.2.18
	approx@0.3.2
	autocfg@1.3.0
	bitflags@2.6.0
	cfg-if@1.0.0
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.20
	either@1.13.0
	equivalent@1.0.1
	fixedbitset@0.4.2
	getrandom@0.2.15
	hashbrown@0.12.3
	hashbrown@0.14.5
	heck@0.4.1
	hermit-abi@0.3.9
	indexmap@1.9.3
	indexmap@2.2.6
	indoc@2.0.5
	itertools@0.10.5
	itertools@0.11.0
	itoa@1.0.11
	libc@0.2.155
	libm@0.2.8
	lock_api@0.4.12
	matrixmultiply@0.3.8
	memchr@2.7.4
	memoffset@0.9.1
	ndarray-stats@0.5.1
	ndarray@0.15.6
	noisy_float@0.2.0
	num-bigint@0.4.6
	num-complex@0.2.4
	num-complex@0.4.6
	num-integer@0.1.46
	num-traits@0.2.19
	num_cpus@1.16.0
	numpy@0.21.0
	once_cell@1.19.0
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	petgraph@0.6.5
	portable-atomic@1.6.0
	ppv-lite86@0.2.17
	priority-queue@2.0.3
	proc-macro2@1.0.86
	pyo3-build-config@0.21.2
	pyo3-ffi@0.21.2
	pyo3-macros-backend@0.21.2
	pyo3-macros@0.21.2
	pyo3@0.21.2
	quick-xml@0.34.0
	quote@1.0.36
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_pcg@0.3.1
	rawpointer@0.2.1
	rayon-cond@0.3.0
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.2
	rustc-hash@1.1.0
	ryu@1.0.18
	scopeguard@1.2.0
	serde@1.0.203
	serde_derive@1.0.203
	serde_json@1.0.118
	smallvec@1.13.2
	sprs@0.11.1
	syn@2.0.68
	target-lexicon@0.12.14
	unicode-ident@1.0.12
	unindent@0.2.3
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.52.5
	zerocopy-derive@0.7.34
	zerocopy@0.7.34
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
	https://github.com/PyO3/pyo3/pull/4324.patch
		-> pyo3-ffi-0.22.1-py313.patch
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 MIT
	Unicode-DFS-2016
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

src_prepare() {
	default

	cd "${ECARGO_VENDOR}"/pyo3-ffi-*/ || die
	eapply -p2 "${DISTDIR}/pyo3-ffi-0.22.1-py313.patch"
}

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
