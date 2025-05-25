# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} )

CRATES="
	asn1@0.21.3
	asn1_derive@0.21.3
	autocfg@1.4.0
	bitflags@2.6.0
	block-buffer@0.10.4
	byteorder@1.5.0
	cc@1.2.2
	cfg-if@1.0.0
	cpufeatures@0.2.16
	crypto-common@0.1.6
	digest@0.10.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	generic-array@0.14.7
	getrandom@0.3.1
	heck@0.5.0
	hex@0.4.3
	indoc@2.0.5
	itoa@1.0.14
	libc@0.2.167
	memoffset@0.9.1
	once_cell@1.20.2
	openssl-macros@0.1.1
	openssl-src@300.4.1+3.4.0
	openssl-sys@0.9.107
	openssl@0.10.72
	pkg-config@0.3.31
	portable-atomic@1.10.0
	ppv-lite86@0.2.20
	proc-macro2@1.0.92
	pyo3-build-config@0.25.0
	pyo3-ffi@0.25.0
	pyo3-macros-backend@0.25.0
	pyo3-macros@0.25.0
	pyo3@0.25.0
	quote@1.0.37
	rand@0.9.1
	rand_chacha@0.9.0
	rand_core@0.9.0
	self_cell@1.2.0
	sha2@0.10.9
	shlex@1.3.0
	syn@2.0.90
	target-lexicon@0.13.2
	typenum@1.17.0
	unicode-ident@1.0.14
	unindent@0.2.3
	vcpkg@0.2.15
	version_check@0.9.5
	wasi@0.13.3+wasi-0.2.2
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	wit-bindgen-rt@0.33.0
	zerocopy-derive@0.7.35
	zerocopy-derive@0.8.14
	zerocopy@0.7.35
	zerocopy@0.8.14
"

declare -A GIT_CRATES=(
	[cryptography-x509]='https://github.com/pyca/cryptography;f81c07535ddf2d26cb1a27e70a9967ab708b8056;cryptography-%commit%/src/rust/cryptography-x509'
)

inherit cargo distutils-r1

DESCRIPTION="An Opinionated Python RFC3161 Client"
HOMEPAGE="
	https://github.com/trailofbits/rfc3161-client/
	https://pypi.org/project/rfc3161-client/
"
# no tests in sdist, as of 0.0.4
SRC_URI="
	https://github.com/trailofbits/rfc3161-client/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-3.0
"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/cryptography-43[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin
	sed -i '/cryptography/s:,<[0-9]*::' pyproject.toml || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest

	# need this for (new) python versions not yet recognized by pyo3
	local -x PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
	cargo_src_test
}
