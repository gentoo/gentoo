# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

CRATES="
	Inflector-0.11.4
	aliasable-0.1.3
	android_system_properties-0.1.5
	asn1-0.12.2
	asn1_derive-0.12.2
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	bumpalo-3.10.0
	cfg-if-1.0.0
	chrono-0.4.22
	core-foundation-sys-0.8.3
	iana-time-zone-0.1.47
	indoc-0.3.6
	indoc-impl-0.3.6
	instant-0.1.12
	js-sys-0.3.59
	libc-0.2.132
	lock_api-0.4.8
	log-0.4.17
	num-integer-0.1.45
	num-traits-0.2.15
	once_cell-1.14.0
	ouroboros-0.15.4
	ouroboros_macro-0.15.4
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	paste-0.1.18
	paste-impl-0.1.18
	pem-1.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro-hack-0.5.19
	proc-macro2-1.0.43
	pyo3-0.15.2
	pyo3-build-config-0.15.2
	pyo3-macros-0.15.2
	pyo3-macros-backend-0.15.2
	quote-1.0.21
	redox_syscall-0.2.16
	scopeguard-1.1.0
	smallvec-1.9.0
	syn-1.0.99
	unicode-ident-1.0.3
	unindent-0.1.10
	version_check-0.9.4
	wasm-bindgen-0.2.82
	wasm-bindgen-backend-0.2.82
	wasm-bindgen-macro-0.2.82
	wasm-bindgen-macro-support-0.2.82
	wasm-bindgen-shared-0.2.82
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo distutils-r1 multiprocessing

VEC_P=cryptography_vectors-$(ver_cut 1-3)
DESCRIPTION="Library providing cryptographic recipes and primitives"
HOMEPAGE="
	https://github.com/pyca/cryptography/
	https://pypi.org/project/cryptography/
"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	$(cargo_crate_uris ${CRATES})
	test? (
		mirror://pypi/c/cryptography_vectors/${VEC_P}.tar.gz
	)
"

# extra licenses come from Rust deps
LICENSE="Apache-2.0 BSD BSD-2 MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv ~s390 sparc x86"

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
	dev-python/setuptools-rust[${PYTHON_USEDEP}]
	test? (
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
	sed -i -e 's:--benchmark-disable::' pyproject.toml || die

	default

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

python_test() {
	local -x PYTHONPATH="${PYTHONPATH}:${WORKDIR}/cryptography_vectors-${PV}"
	local EPYTEST_IGNORE=(
		tests/bench
	)
	epytest -n "$(makeopts_jobs)"
}
