# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE="threads(+)"

CRATES="
	asn1@0.15.5
	asn1_derive@0.15.5
	autocfg@1.1.0
	base64@0.21.7
	bitflags@1.3.2
	bitflags@2.4.2
	cc@1.0.83
	cfg-if@1.0.0
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	heck@0.4.1
	indoc@2.0.4
	libc@0.2.152
	lock_api@0.4.11
	memoffset@0.9.0
	once_cell@1.19.0
	openssl-macros@0.1.1
	openssl-sys@0.9.102
	openssl@0.10.64
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	pem@3.0.3
	pkg-config@0.3.29
	portable-atomic@1.6.0
	proc-macro2@1.0.78
	pyo3-build-config@0.20.3
	pyo3-ffi@0.20.3
	pyo3-macros-backend@0.20.3
	pyo3-macros@0.20.3
	pyo3@0.20.3
	quote@1.0.35
	redox_syscall@0.4.1
	scopeguard@1.2.0
	self_cell@1.0.3
	smallvec@1.13.1
	syn@2.0.48
	target-lexicon@0.12.13
	unicode-ident@1.0.12
	unindent@0.2.3
	vcpkg@0.2.15
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
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
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 sparc ~x86"

RDEPEND="
	>=dev-libs/openssl-1.0.2o-r6:0=
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.8:=[${PYTHON_USEDEP}]
	' 'python*')
"
DEPEND="
	${RDEPEND}
"
# XXX: Drop explicit >=virtual/rust-1.56.0 dep once that's the minimum in cargo.eclass
# and replace it with ${RUST_DEPEND}
BDEPEND="
	>=dev-python/setuptools-rust-1.7.0[${PYTHON_USEDEP}]
	>=virtual/rust-1.56.0
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
