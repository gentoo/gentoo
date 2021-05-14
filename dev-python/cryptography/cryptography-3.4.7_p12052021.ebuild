# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CARGO_OPTIONAL=yes
PYTHON_COMPAT=( python3_{7..10} )
PYTHON_REQ_USE="threads(+)"

inherit cargo distutils-r1 multiprocessing

CRYPTOGRAPHY_SRC_HASH=1b922ed1dee0cd7e165a868639ce6d0869c8b2f5
CRATES="
asn1-0.4.2
asn1_derive-0.4.2
autocfg-1.0.1
bitflags-1.2.1
cfg-if-1.0.0
chrono-0.4.19
ctor-0.1.20
ghost-0.1.2
indoc-0.3.6
indoc-impl-0.3.6
instant-0.1.9
inventory-0.1.10
inventory-impl-0.1.10
lazy_static-1.4.0
libc-0.2.94
lock_api-0.4.4
num-integer-0.1.44
num-traits-0.2.14
parking_lot-0.11.1
parking_lot_core-0.8.3
paste-0.1.18
paste-impl-0.1.18
proc-macro-hack-0.5.19
proc-macro2-1.0.26
pyo3-0.13.2
pyo3-macros-0.13.2
pyo3-macros-backend-0.13.2
quote-1.0.9
redox_syscall-0.2.8
scopeguard-1.1.0
smallvec-1.6.1
syn-1.0.72
unicode-xid-0.2.2
unindent-0.1.7
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

# VEC_P=cryptography_vectors-$(ver_cut 1-3)
DESCRIPTION="Library providing cryptographic recipes and primitives"
HOMEPAGE="https://github.com/pyca/cryptography/ https://pypi.org/project/cryptography/"
SRC_URI="https://github.com/pyca/${PN}/archive/${CRYPTOGRAPHY_SRC_HASH}.tar.gz -> ${PF}.tar.gz
	$(cargo_crate_uris ${CRATES})"
# test? ( mirror://pypi/c/cryptography_vectors/${VEC_P}.tar.gz )
# SRC_URI changed to commit with the test fixes

# MIT and BSD-3-Clause come from rust dependencies, some dependencies are also Apache 2.0 exclusively,
# and some are Apache 2.0 or MIT
LICENSE="Apache-2.0 MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

DEPEND="
	>=dev-libs/openssl-1.0.2o-r6:0=
"
RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/cffi-1.8:=[${PYTHON_USEDEP}]
	' 'python*')
"
BDEPEND="
	${DEPEND}
	dev-python/setuptools_rust[${PYTHON_USEDEP}]
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

S="${WORKDIR}/cryptography-${CRYPTOGRAPHY_SRC_HASH}"

# Files built without CFLAGS/LDFLAGS, acceptable for rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/cryptography/hazmat/bindings/_rust.abi3.so"

distutils_enable_tests pytest

src_unpack() {
	cargo_src_unpack
}

src_prepare() {
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
	local -x PYTHONPATH="${PYTHONPATH}:${S}/vectors"
	epytest -n "$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")"
}
