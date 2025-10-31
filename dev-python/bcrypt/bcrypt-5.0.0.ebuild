# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
# TODO: freethreading
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

RUST_MIN_VER="1.82.0"
CRATES="
	autocfg@1.5.0
	base64@0.22.1
	bcrypt-pbkdf@0.10.0
	bcrypt@0.17.1
	block-buffer@0.10.4
	blowfish@0.9.1
	byteorder@1.5.0
	cfg-if@1.0.3
	cipher@0.4.4
	cpufeatures@0.2.17
	crypto-common@0.1.6
	digest@0.10.7
	generic-array@0.14.7
	getrandom@0.3.3
	heck@0.5.0
	indoc@2.0.6
	inout@0.1.4
	libc@0.2.176
	memoffset@0.9.1
	once_cell@1.21.3
	pbkdf2@0.12.2
	portable-atomic@1.11.1
	proc-macro2@1.0.101
	pyo3-build-config@0.26.0
	pyo3-ffi@0.26.0
	pyo3-macros-backend@0.26.0
	pyo3-macros@0.26.0
	pyo3@0.26.0
	quote@1.0.40
	r-efi@5.3.0
	sha2@0.10.9
	subtle@2.6.1
	syn@2.0.106
	target-lexicon@0.13.3
	typenum@1.18.0
	unicode-ident@1.0.19
	unindent@0.2.4
	version_check@0.9.5
	wasi@0.14.7+wasi-0.2.4
	wasip2@1.0.1+wasi-0.2.4
	wit-bindgen@0.46.0
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
LICENSE+=" Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-3.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	>=dev-python/setuptools-rust-1.7.0[${PYTHON_USEDEP}]
"

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/bcrypt/_bcrypt.*.so"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	pushd "${ECARGO_VENDOR}"/pyo3-0*/ >/dev/null || die
	eapply "${FILESDIR}/bcrypt-4.2.0-patch-pyo3-subinterp.patch"
	popd >/dev/null || die
}

python_configure_all() {
	# Workaround for sys-cluster/ceph (bug #920906)
	# https://github.com/pyca/bcrypt/issues/694
	# https://github.com/PyO3/pyo3/issues/3451
	export RUSTFLAGS="${RUSTFLAGS} --cfg pyo3_unsafe_allow_subinterpreters"
}

python_test() {
	epytest tests
}
