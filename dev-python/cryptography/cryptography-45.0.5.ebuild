# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="threads(+)"

CRATES="
	asn1@0.21.3
	asn1_derive@0.21.3
	autocfg@1.4.0
	base64@0.22.1
	bitflags@2.9.1
	cc@1.2.23
	cfg-if@1.0.0
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	heck@0.5.0
	indoc@2.0.6
	itoa@1.0.15
	libc@0.2.172
	memoffset@0.9.1
	once_cell@1.21.3
	openssl-macros@0.1.1
	openssl-sys@0.9.108
	openssl@0.10.72
	pem@3.0.5
	pkg-config@0.3.32
	portable-atomic@1.11.0
	proc-macro2@1.0.95
	pyo3-build-config@0.25.0
	pyo3-ffi@0.25.0
	pyo3-macros-backend@0.25.0
	pyo3-macros@0.25.0
	pyo3@0.25.0
	quote@1.0.40
	self_cell@1.2.0
	shlex@1.3.0
	syn@2.0.101
	target-lexicon@0.13.2
	unicode-ident@1.0.18
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
	)
"

LICENSE="|| ( Apache-2.0 BSD ) PSF-2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~loong ~mips ppc ~ppc64 ~riscv ~s390 ~sparc x86"

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
	>=dev-util/maturin-1.8.6[${PYTHON_USEDEP}]
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
	local -x PYTHONPATH="${PYTHONPATH}:${WORKDIR}/cryptography_vectors-${PV}"
	local EPYTEST_IGNORE=(
		tests/bench
	)
	epytest
}
