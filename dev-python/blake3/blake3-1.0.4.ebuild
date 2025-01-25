# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..13} )

CRATES="
	arrayref@0.3.9
	arrayvec@0.7.6
	autocfg@1.4.0
	blake3@1.5.5
	cc@1.2.9
	cfg-if@1.0.0
	constant_time_eq@0.3.1
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	either@1.13.0
	heck@0.5.0
	hex@0.4.3
	indoc@2.0.5
	libc@0.2.169
	memmap2@0.9.5
	memoffset@0.9.1
	once_cell@1.20.2
	portable-atomic@1.10.0
	proc-macro2@1.0.93
	pyo3-build-config@0.23.4
	pyo3-ffi@0.23.4
	pyo3-macros-backend@0.23.4
	pyo3-macros@0.23.4
	pyo3@0.23.4
	quote@1.0.38
	rayon-core@1.12.1
	rayon@1.10.0
	shlex@1.3.0
	syn@2.0.96
	target-lexicon@0.12.16
	unicode-ident@1.0.14
	unindent@0.2.3
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
	Apache-2.0-with-LLVM-exceptions BSD-2 MIT Unicode-3.0
	|| ( Apache-2.0 CC0-1.0 MIT-0 )
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

pkg_setup() {
	use rust && rust_pkg_setup
}

src_unpack() {
	# Do this unconditionally as it has sensible behaviour even
	# w/ USE=-rust.
	cargo_src_unpack
}

src_prepare() {
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
