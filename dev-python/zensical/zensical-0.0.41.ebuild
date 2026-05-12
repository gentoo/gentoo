# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{13..14} )

CARGO_OPTIONAL=1
RUST_MIN_VER="1.86"
CRATES="
	ahash@0.8.12
	aho-corasick@1.1.4
	anyhow@1.0.102
	ariadne@0.6.0
	base64@0.22.1
	bitflags@1.3.2
	bitflags@2.10.0
	borrow-or-share@0.2.4
	bstr@1.12.1
	bumpalo@3.19.1
	bytes@1.11.1
	cfg-if@1.0.4
	combine@4.6.7
	core-foundation-sys@0.8.7
	core-foundation@0.10.1
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-queue@0.3.12
	crossbeam-utils@0.8.21
	crossbeam@0.8.4
	displaydoc@0.2.5
	file-id@0.2.3
	fluent-uri@0.4.1
	form_urlencoded@1.2.2
	fsevent-sys@4.1.0
	getrandom@0.3.4
	globset@0.4.18
	heck@0.5.0
	httparse@1.10.1
	httpdate@1.0.3
	icu_collections@2.1.1
	icu_locale_core@2.1.1
	icu_normalizer@2.1.1
	icu_normalizer_data@2.1.1
	icu_properties@2.1.2
	icu_properties_data@2.1.2
	icu_provider@2.1.1
	idna@1.1.0
	idna_adapter@1.2.1
	inotify-sys@0.1.5
	inotify@0.11.0
	itoa@1.0.16
	jni-macros@0.22.4
	jni-sys-macros@0.4.1
	jni-sys@0.4.1
	jni@0.22.4
	js-sys@0.3.83
	kqueue-sys@1.0.4
	kqueue@1.1.1
	lazy_static@1.5.0
	libc@0.2.185
	litemap@0.8.1
	log@0.4.29
	matchit@0.9.2
	memchr@2.7.6
	memo-map@0.3.3
	minijinja-contrib@2.19.0
	minijinja@2.19.0
	mio@1.2.0
	ndk-context@0.1.1
	notify-types@2.0.0
	notify@8.2.0
	nu-ansi-term@0.50.3
	objc2-encode@4.1.0
	objc2-foundation@0.3.2
	objc2@0.6.3
	once_cell@1.21.3
	percent-encoding@2.3.2
	pin-project-lite@0.2.16
	portable-atomic@1.12.0
	potential_utf@0.1.4
	ppv-lite86@0.2.21
	proc-macro2@1.0.103
	pyo3-build-config@0.28.3
	pyo3-ffi@0.28.3
	pyo3-macros-backend@0.28.3
	pyo3-macros@0.28.3
	pyo3@0.28.3
	quote@1.0.42
	r-efi@5.3.0
	rand@0.9.4
	rand_chacha@0.9.0
	rand_core@0.9.3
	ref-cast-impl@1.0.25
	ref-cast@1.0.25
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.3
	rustc_version@0.4.1
	rustversion@1.0.22
	same-file@1.0.6
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	sha1_smol@1.0.1
	sharded-slab@0.1.7
	simd_cesu8@1.1.1
	simdutf8@0.1.5
	slab@0.4.12
	smallvec@1.15.1
	stable_deref_trait@1.2.1
	syn@2.0.111
	synstructure@0.13.2
	target-lexicon@0.13.4
	thiserror-impl@2.0.18
	thiserror@2.0.18
	thread_local@1.1.9
	tinystr@0.8.2
	tracing-attributes@0.1.31
	tracing-chrome@0.7.2
	tracing-core@0.1.36
	tracing-log@0.2.0
	tracing-subscriber@0.3.23
	tracing@0.1.44
	tungstenite@0.29.0
	unicode-ident@1.0.22
	unicode-width@0.2.2
	url@2.5.7
	utf8_iter@1.0.4
	valuable@0.1.1
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-macro-support@0.2.106
	wasm-bindgen-macro@0.2.106
	wasm-bindgen-shared@0.2.106
	wasm-bindgen@0.2.106
	web-sys@0.3.83
	webbrowser@1.2.1
	winapi-util@0.1.11
	windows-link@0.2.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	wit-bindgen@0.46.0
	writeable@0.6.2
	yansi@1.0.1
	yoke-derive@0.8.1
	yoke@0.8.1
	zerocopy-derive@0.8.31
	zerocopy@0.8.31
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zerotrie@0.2.3
	zerovec-derive@0.11.2
	zerovec@0.11.5
	zmij@1.0.16
	zrx-diagnostic@0.0.2
	zrx-executor@0.0.6
	zrx-graph@0.0.12
	zrx-id@0.0.20
	zrx-module@0.0.8
	zrx-path@0.0.1
	zrx-scheduler@0.0.21
	zrx-storage@0.0.4
	zrx-store@0.0.10
	zrx-stream@0.0.21
	zrx@0.0.24
"

inherit distutils-r1 cargo

DESCRIPTION="A modern static site generator by the Material for MkDocs team"
HOMEPAGE="https://zensical.org https://github.com/zensical/zensical"

UI_V="0.0.17"
UI_N="${PN}-ui-${UI_V}"

SRC_URI="
	https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/${PN}/ui/archive/refs/tags/v${UI_V}.tar.gz -> ${UI_N}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD CC0-1.0 ISC MIT MIT-0
	Unicode-3.0
"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="!test? ( test )"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/click[${PYTHON_USEDEP}]
		dev-python/deepmerge[${PYTHON_USEDEP}]
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pymdown-extensions[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/tomli[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
	${RUST_DEPEND}
	$(python_gen_cond_dep '
		dev-util/maturin[${PYTHON_USEDEP}]

		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/tabulate[${PYTHON_USEDEP}]
		)
	')
"

src_unpack() {
	cargo_src_unpack
}

src_prepare() {
	default

	# Assets from the UI repo need to be copied over
	# https://github.com/zensical/zensical/blob/master/scripts/dev.py
	mv "${WORKDIR}/ui-${UI_V}/dist" "${WORKDIR}/${P}/python/zensical/templates" || die
}

python_test() {
	# Because there is a directory named "zensical", python prioritizes that instead of the installed package.
	# So the tests need to be moved somewhere else.
	mv python/tests tests/

	epytest tests/
}

python_test_all() {
	# These don't compile at all
	local CARGO_SKIP_TESTS=(
		agent::Agent::unwatch
		agent::Agent::watch
	)

	pushd crates/zensical || die
	cargo_src_test
	popd

	pushd crates/zensical-serve || die
	cargo_src_test
	popd

	pushd crates/zensical-watch || die
	cargo_src_test
	popd
}
