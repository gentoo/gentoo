# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	autocfg@1.4.0
	cfg-if@1.0.0
	displaydoc@0.2.5
	heck@0.5.0
	icu_collections@1.5.0
	icu_locid@1.5.0
	icu_locid_transform@1.5.0
	icu_locid_transform_data@1.5.0
	icu_normalizer@1.5.0
	icu_normalizer_data@1.5.0
	icu_properties@1.5.1
	icu_properties_data@1.5.0
	icu_provider@1.5.0
	icu_provider_macros@1.5.0
	idna@1.0.3
	idna_adapter@1.2.0
	indoc@2.0.5
	jid@0.12.0
	libc@0.2.170
	litemap@0.7.5
	memchr@2.7.4
	memoffset@0.9.1
	once_cell@1.20.3
	portable-atomic@1.11.0
	proc-macro2@1.0.93
	pyo3-build-config@0.23.5
	pyo3-ffi@0.23.5
	pyo3-macros-backend@0.23.5
	pyo3-macros@0.23.5
	pyo3@0.23.5
	quote@1.0.38
	serde@1.0.218
	serde_derive@1.0.218
	smallvec@1.14.0
	stable_deref_trait@1.2.0
	stringprep@0.1.5
	syn@2.0.98
	synstructure@0.13.1
	target-lexicon@0.12.16
	tinystr@0.7.6
	tinyvec@1.8.1
	tinyvec_macros@0.1.1
	unicode-bidi@0.3.18
	unicode-ident@1.0.17
	unicode-normalization@0.1.24
	unicode-properties@0.1.3
	unindent@0.2.3
	utf16_iter@1.0.5
	utf8_iter@1.0.4
	write16@1.0.0
	writeable@0.5.5
	yoke-derive@0.7.5
	yoke@0.7.5
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerovec-derive@0.10.3
	zerovec@0.10.4
"

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{10..13} )

inherit cargo distutils-r1 pypi

DESCRIPTION="Python 3 library for XMPP"
HOMEPAGE="
	https://codeberg.org/poezio/slixmpp/
	https://pypi.org/project/slixmpp/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-python/aiodns-3.2.0[${PYTHON_USEDEP}]
	dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/emoji[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.6.1[${PYTHON_USEDEP}]
"

# Rust
QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/slixmpp/jid.*.so"

distutils_enable_tests unittest

python_test() {
	rm -rf slixmpp || die
	eunittest -s tests
}
