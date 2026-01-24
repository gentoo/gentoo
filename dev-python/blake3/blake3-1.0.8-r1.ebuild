# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} )

RUST_MIN_VER="1.80.0"
CRATES="
	arrayref@0.3.9
	arrayvec@0.7.6
	autocfg@1.5.0
	blake3@1.8.2
	cc@1.2.39
	cfg-if@1.0.3
	constant_time_eq@0.3.1
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	either@1.15.0
	find-msvc-tools@0.1.2
	heck@0.5.0
	hex@0.4.3
	indoc@2.0.6
	libc@0.2.176
	memmap2@0.9.8
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	pyo3-build-config@0.26.0
	pyo3-ffi@0.26.0
	pyo3-macros-backend@0.26.0
	pyo3-macros@0.26.0
	pyo3@0.26.0
	quote@1.0.41
	rayon-core@1.13.0
	rayon@1.11.0
	shlex@1.3.0
	syn@2.0.106
	target-lexicon@0.13.3
	unicode-ident@1.0.19
	unindent@0.2.4
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

DEPEND="
	!rust? ( dev-libs/blake3:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${DEPEND}
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

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_setup() {
	use rust && rust_pkg_setup
}

src_unpack() {
	# Do this unconditionally as it has sensible behaviour even
	# w/ USE=-rust.
	cargo_src_unpack
}

PATCHES=(
	# Link against shared blake3 library. Bug 943281.
	"${FILESDIR}/${P}-use-installed-library.patch"
)

src_prepare() {
	distutils-r1_src_prepare

	# sed the package name and version to improve compatibility
	sed -e 's:blake3_experimental_c:blake3:' \
		-e "s:0[.]0[.]1:${PV}:" \
		-i c_impl/setup.py || die

	# remove vendored C sources to ensure we don't use accidentally
	rm -r c_impl/vendor || die
}

python_compile() {
	local DISTUTILS_USE_PEP517=$(usex rust maturin setuptools)

	if ! use rust; then
		export FORCE_SYSTEM_BLAKE3=1
		cd c_impl || die
	fi
	distutils-r1_python_compile
	if ! use rust; then
		cd - >/dev/null || die
	fi
}
