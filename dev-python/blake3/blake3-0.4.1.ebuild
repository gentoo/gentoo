# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..13} )

CRATES="
	arrayref@0.3.7
	arrayvec@0.7.4
	autocfg@1.1.0
	bitflags@1.3.2
	blake3@1.5.0
	cc@1.0.83
	cfg-if@1.0.0
	constant_time_eq@0.3.0
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	either@1.9.0
	heck@0.4.1
	hex@0.4.3
	indoc@2.0.4
	libc@0.2.153
	lock_api@0.4.11
	memmap2@0.7.1
	memoffset@0.9.0
	once_cell@1.19.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	proc-macro2@1.0.78
	pyo3-build-config@0.20.2
	pyo3-ffi@0.20.2
	pyo3-macros-backend@0.20.2
	pyo3-macros@0.20.2
	pyo3@0.20.2
	quote@1.0.35
	rayon-core@1.12.1
	rayon@1.8.1
	redox_syscall@0.4.1
	scopeguard@1.2.0
	smallvec@1.13.1
	syn@2.0.48
	target-lexicon@0.12.13
	unicode-ident@1.0.12
	unindent@0.2.3
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
"

inherit cargo distutils-r1

MY_P=blake3-py-${PV}
DESCRIPTION="Python bindings for the BLAKE3 cryptographic hash function"
HOMEPAGE="
	https://github.com/oconnor663/blake3-py/
	https://pypi.org/project/blake3/
"
SRC_URI="
	https://github.com/oconnor663/blake3-py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
	rust? (
		${CARGO_CRATE_URIS}
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="
	|| ( CC0-1.0 Apache-2.0 )
	rust? (
"
# Dependent crate licenses
LICENSE+="
	Apache-2.0-with-LLVM-exceptions BSD-2 MIT Unicode-DFS-2016
	|| ( Apache-2.0 CC0-1.0 )
"
LICENSE+="
	)
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+rust"

BDEPEND="
	rust? (
		${RUST_DEPEND}
		dev-util/maturin[${PYTHON_USEDEP}]
	)
	!rust? (
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/blake3/blake3.*.so"

distutils_enable_tests pytest

src_unpack() {
	cargo_src_unpack
}

src_prepare() {
	local PATCHES=(
		# https://github.com/oconnor663/blake3-py/pull/44
		"${FILESDIR}/${P}-gcc14.patch"
	)

	# sed the package name and version to improve compatibility
	sed -e 's:blake3_experimental_c:blake3:' \
		-e "s:0[.]0[.]1:${PV}:" \
		-i c_impl/setup.py || die

	distutils-r1_src_prepare
}

python_compile() {
	local DISTUTILS_USE_PEP517=$(usex rust maturin setuptools)

	if ! use rust; then
		cd c_impl || die
	fi
	distutils-r1_python_compile
	if ! use rust; then
		cd - >/dev/null || die
	fi
}
