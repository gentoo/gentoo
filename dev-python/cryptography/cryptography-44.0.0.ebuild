# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE="threads(+)"

CRATES="
	asn1@0.20.0
	asn1_derive@0.20.0
	autocfg@1.4.0
	base64@0.22.1
	bitflags@2.6.0
	cc@1.2.1
	cfg-if@1.0.0
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	heck@0.5.0
	indoc@2.0.5
	itoa@1.0.14
	libc@0.2.166
	memoffset@0.9.1
	once_cell@1.20.2
	openssl-macros@0.1.1
	openssl-sys@0.9.104
	openssl@0.10.68
	pem@3.0.4
	pkg-config@0.3.31
	portable-atomic@1.10.0
	proc-macro2@1.0.92
	pyo3-build-config@0.23.2
	pyo3-ffi@0.23.2
	pyo3-macros-backend@0.23.2
	pyo3-macros@0.23.2
	pyo3@0.23.2
	quote@1.0.37
	self_cell@1.0.4
	shlex@1.3.0
	syn@2.0.89
	target-lexicon@0.12.16
	unicode-ident@1.0.14
	unindent@0.2.3
	vcpkg@0.2.15
"

inherit cargo distutils-r1 flag-o-matic multiprocessing pypi

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
		>=dev-python/cffi-1.8:=[${PYTHON_USEDEP}]
	' 'python*')
"
DEPEND="
	${RDEPEND}
"

BDEPEND="
	${RUST_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/certifi[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-1.11.4[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/pretend[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		dev-python/pytest-subtests[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

# Files built without CFLAGS/LDFLAGS, acceptable for rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/cryptography/hazmat/bindings/_rust.*.so"

distutils_enable_tests pytest

src_unpack() {
	cargo_src_unpack
}

src_prepare() {
	default

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

	export UNSAFE_PYO3_SKIP_VERSION_CHECK=1
}

python_test() {
	local -x PYTHONPATH="${PYTHONPATH}:${WORKDIR}/cryptography_vectors-${PV}"
	local EPYTEST_IGNORE=(
		tests/bench
	)
	epytest -n "$(makeopts_jobs)"
}
