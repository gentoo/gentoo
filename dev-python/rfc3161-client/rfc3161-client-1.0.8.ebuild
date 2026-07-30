# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{12..15} )

RUST_MIN_VER="1.87.0"
CRATES="
	anyhow@1.0.102
	asn1@0.24.1
	asn1_derive@0.24.1
	bitflags@2.11.1
	block-buffer@0.12.0
	cc@1.2.60
	cfg-if@1.0.4
	chacha20@0.10.0
	const-oid@0.10.2
	cpufeatures@0.3.0
	crypto-common@0.2.1
	digest@0.11.2
	equivalent@1.0.2
	find-msvc-tools@0.1.9
	foldhash@0.1.5
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	getrandom@0.4.2
	hashbrown@0.15.5
	hashbrown@0.17.0
	heck@0.5.0
	hex@0.4.3
	hybrid-array@0.4.10
	id-arena@2.3.0
	indexmap@2.14.0
	itoa@1.0.18
	leb128fmt@0.1.0
	libc@0.2.185
	log@0.4.29
	memchr@2.8.0
	once_cell@1.21.4
	openssl-macros@0.1.1
	openssl-src@300.6.0+3.6.2
	openssl-sys@0.9.117
	openssl@0.10.81
	pkg-config@0.3.33
	portable-atomic@1.13.1
	prettyplease@0.2.37
	proc-macro2@1.0.106
	pyo3-build-config@0.29.0
	pyo3-ffi@0.29.0
	pyo3-macros-backend@0.29.0
	pyo3-macros@0.29.0
	pyo3@0.29.0
	quote@1.0.45
	r-efi@6.0.0
	rand@0.10.2
	rand_core@0.10.1
	self_cell@1.3.0
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	sha2@0.11.0
	shlex@1.3.0
	syn@2.0.117
	target-lexicon@0.13.5
	typenum@1.19.0
	unicode-ident@1.0.24
	unicode-xid@0.2.6
	vcpkg@0.2.15
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	zmij@1.0.21
"

declare -A GIT_CRATES=(
	[cryptography-x509]='https://github.com/pyca/cryptography;e300bbe2f1bec75e5ee7e0ab7b196958831b3db6;cryptography-%commit%/src/rust/cryptography-x509'
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
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD MIT Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

RDEPEND="
	>=dev-python/cryptography-43[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pretend[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest

	# need this for (new) python versions not yet recognized by pyo3
	local -x PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1
	cargo_src_test
}
