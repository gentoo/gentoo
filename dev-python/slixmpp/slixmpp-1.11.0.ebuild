# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..13} )

CRATES="
	autocfg@1.5.0
	cfg-if@1.0.3
	displaydoc@0.2.5
	heck@0.5.0
	icu_collections@2.0.0
	icu_locale_core@2.0.0
	icu_normalizer@2.0.0
	icu_normalizer_data@2.0.0
	icu_properties@2.0.1
	icu_properties_data@2.0.1
	icu_provider@2.0.0
	idna@1.1.0
	idna_adapter@1.2.1
	indoc@2.0.6
	jid@0.12.0
	libc@0.2.175
	litemap@0.8.0
	memchr@2.7.5
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.1
	potential_utf@0.1.3
	proc-macro2@1.0.101
	pyo3-build-config@0.23.5
	pyo3-ffi@0.23.5
	pyo3-macros-backend@0.23.5
	pyo3-macros@0.23.5
	pyo3@0.23.5
	quote@1.0.40
	serde@1.0.219
	serde_derive@1.0.219
	smallvec@1.15.1
	stable_deref_trait@1.2.0
	stringprep@0.1.5
	syn@2.0.106
	synstructure@0.13.2
	target-lexicon@0.12.16
	tinystr@0.8.1
	tinyvec@1.10.0
	tinyvec_macros@0.1.1
	unicode-bidi@0.3.18
	unicode-ident@1.0.18
	unicode-normalization@0.1.24
	unicode-properties@0.1.3
	unindent@0.2.4
	utf8_iter@1.0.4
	writeable@0.6.1
	yoke-derive@0.8.0
	yoke@0.8.0
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerotrie@0.2.2
	zerovec-derive@0.11.1
	zerovec@0.11.4
"

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
