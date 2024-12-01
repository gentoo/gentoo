# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

CRATES="
	autocfg@1.4.0
	base64@0.22.1
	bcrypt-pbkdf@0.10.0
	bcrypt@0.16.0
	block-buffer@0.10.4
	blowfish@0.9.1
	byteorder@1.5.0
	cfg-if@1.0.0
	cipher@0.4.4
	cpufeatures@0.2.15
	crypto-common@0.1.6
	digest@0.10.7
	generic-array@0.14.7
	getrandom@0.2.15
	heck@0.5.0
	indoc@2.0.5
	inout@0.1.3
	libc@0.2.164
	memoffset@0.9.1
	once_cell@1.20.2
	pbkdf2@0.12.2
	portable-atomic@1.9.0
	proc-macro2@1.0.89
	pyo3-build-config@0.23.1
	pyo3-ffi@0.23.1
	pyo3-macros-backend@0.23.1
	pyo3-macros@0.23.1
	pyo3@0.23.1
	quote@1.0.37
	sha2@0.10.8
	subtle@2.6.1
	syn@2.0.87
	target-lexicon@0.12.16
	typenum@1.17.0
	unicode-ident@1.0.13
	unindent@0.2.3
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	zeroize@1.8.1
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Modern password hashing for software and servers"
HOMEPAGE="
	https://github.com/pyca/bcrypt/
	https://pypi.org/project/bcrypt/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

BDEPEND="
	>=dev-python/setuptools-rust-1.7.0[${PYTHON_USEDEP}]
"

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/bcrypt/_bcrypt.*.so"

distutils_enable_tests pytest

export UNSAFE_PYO3_SKIP_VERSION_CHECK=1

src_prepare() {
	distutils-r1_src_prepare

	cd "${ECARGO_VENDOR}"/pyo3-0*/ || die
	eapply "${FILESDIR}/bcrypt-4.2.0-patch-pyo3-subinterp.patch"
}

python_configure_all() {
	# Workaround for sys-cluster/ceph (bug #920906)
	# https://github.com/pyca/bcrypt/issues/694
	# https://github.com/PyO3/pyo3/issues/3451
	export RUSTFLAGS="${RUSTFLAGS} --cfg pyo3_unsafe_allow_subinterpreters"
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest tests
}
