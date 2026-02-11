# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYPI_VERIFY_REPO=https://github.com/pyca/cryptography
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="threads(+)"

CRATES="
	asn1@0.22.0
	asn1_derive@0.22.0
	autocfg@1.5.0
	base64@0.22.1
	bitflags@2.9.4
	cc@1.2.37
	cfg-if@1.0.3
	find-msvc-tools@0.1.1
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	heck@0.5.0
	indoc@2.0.6
	itoa@1.0.15
	libc@0.2.175
	memoffset@0.9.1
	once_cell@1.21.3
	openssl-macros@0.1.1
	openssl-sys@0.9.110
	openssl@0.10.74
	pem@3.0.5
	pkg-config@0.3.32
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	pyo3-build-config@0.26.0
	pyo3-ffi@0.26.0
	pyo3-macros-backend@0.26.0
	pyo3-macros@0.26.0
	pyo3@0.26.0
	quote@1.0.40
	self_cell@1.2.0
	shlex@1.3.0
	syn@2.0.106
	target-lexicon@0.13.3
	unicode-ident@1.0.19
	unindent@0.2.4
	vcpkg@0.2.15
"

inherit cargo distutils-r1 flag-o-matic pypi

VEC_P=cryptography_vectors-$(ver_cut 1-3)
DESCRIPTION="Library providing cryptographic recipes and primitives"
HOMEPAGE="
	https://github.com/pyca/cryptography/
	https://pypi.org/project/cryptography/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
	test? (
		$(pypi_sdist_url cryptography_vectors "$(ver_cut 1-3)")
		$(pypi_provenance_url "${VEC_P}.tar.gz" cryptography_vectors "$(ver_cut 1-3)")
			-> ${VEC_P}.tar.gz.provenance
	)
"

LICENSE="|| ( Apache-2.0 BSD ) PSF-2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-libs/openssl-1.0.2o-r6:0=
	$(python_gen_cond_dep '
		>=dev-python/cffi-2.0.0:=[${PYTHON_USEDEP}]
	' 'python*')
"
DEPEND="
	${RDEPEND}
"

BDEPEND="
	${RUST_DEPEND}
	>=dev-util/maturin-1.9.4[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/certifi[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

# Files built without CFLAGS/LDFLAGS, acceptable for rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/cryptography/hazmat/bindings/_rust.*.so"

EPYTEST_PLUGINS=( hypothesis pytest-subtests )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_unpack() {
	if use verify-provenance; then
		pypi_verify_provenance "${DISTDIR}/${P}.tar.gz"{,.provenance}
		use test && pypi_verify_provenance "${DISTDIR}/${VEC_P}.tar.gz"{,.provenance}
	fi

	cargo_src_unpack
}

src_prepare() {
	distutils-r1_src_prepare

	sed -i -e 's:--benchmark-disable::' pyproject.toml || die

	# work around availability macros not supported in GCC (yet)
	if [[ ${CHOST} == *-darwin* ]] ; then
		local darwinok=0
		if [[ ${CHOST##*-darwin} -ge 16 ]] ; then
			darwinok=1
		fi
		sed -i -e 's/__builtin_available(macOS 10\.12, \*)/'"${darwinok}"'/' \
			src/_cffi_src/openssl/src/osrandom_engine.c || die
	fi
}

python_configure_all() {
	filter-lto # bug #903908
}

python_test() {
	local -x PYTHONPATH="${PYTHONPATH}:${WORKDIR}/${VEC_P}"
	local EPYTEST_IGNORE=(
		tests/bench
	)
	epytest
}
