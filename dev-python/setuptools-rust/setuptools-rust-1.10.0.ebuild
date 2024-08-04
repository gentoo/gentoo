# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

CRATES="
	autocfg@1.3.0
	bitflags@1.3.2
	bitflags@2.5.0
	byteorder@1.5.0
	cfg-if@1.0.0
	convert_case@0.4.0
	cssparser-macros@0.6.1
	cssparser@0.27.2
	derive_more@0.99.17
	dtoa-short@0.3.4
	dtoa@1.0.9
	futf@0.1.5
	fxhash@0.2.1
	getrandom@0.1.16
	getrandom@0.2.15
	heck@0.5.0
	html5ever@0.25.2
	indoc@2.0.5
	itoa@0.4.8
	kuchiki@0.8.1
	libc@0.2.154
	lock_api@0.4.12
	log@0.4.21
	mac@0.1.1
	markup5ever@0.10.1
	matches@0.1.10
	memoffset@0.9.1
	new_debug_unreachable@1.0.6
	nodrop@0.1.14
	once_cell@1.19.0
	parking_lot@0.12.2
	parking_lot_core@0.9.10
	phf@0.8.0
	phf_codegen@0.8.0
	phf_generator@0.10.0
	phf_generator@0.8.0
	phf_macros@0.8.0
	phf_shared@0.10.0
	phf_shared@0.8.0
	portable-atomic@1.6.0
	ppv-lite86@0.2.17
	precomputed-hash@0.1.1
	proc-macro-hack@0.5.20+deprecated
	proc-macro2@1.0.82
	pyo3-build-config@0.22.2
	pyo3-ffi@0.22.2
	pyo3-macros-backend@0.22.2
	pyo3-macros@0.22.2
	pyo3@0.22.2
	quote@1.0.36
	rand@0.7.3
	rand@0.8.5
	rand_chacha@0.2.2
	rand_chacha@0.3.1
	rand_core@0.5.1
	rand_core@0.6.4
	rand_hc@0.2.0
	rand_pcg@0.2.1
	redox_syscall@0.5.1
	rustc_version@0.4.0
	scopeguard@1.2.0
	selectors@0.22.0
	semver@1.0.23
	serde@1.0.200
	serde_derive@1.0.200
	servo_arc@0.1.1
	siphasher@0.3.11
	smallvec@1.13.2
	stable_deref_trait@1.2.0
	string_cache@0.8.7
	string_cache_codegen@0.5.2
	syn@1.0.109
	syn@2.0.61
	target-lexicon@0.12.14
	tendril@0.4.3
	thin-slice@0.1.1
	unicode-ident@1.0.12
	unindent@0.2.3
	utf-8@0.7.6
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.9.0+wasi-snapshot-preview1
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.52.5
"

inherit distutils-r1 cargo

DESCRIPTION="A plugin for setuptools to build Rust Python extensions"
HOMEPAGE="
	https://github.com/PyO3/setuptools-rust/
	https://pypi.org/project/setuptools-rust/
"
SRC_URI="
	https://github.com/PyO3/setuptools-rust/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? ( ${CARGO_CRATE_URIS} )
"

# crates are used at test time only, update via pycargoebuild -L -i ...
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/rust
	<dev-python/semantic-version-3[${PYTHON_USEDEP}]
	>=dev-python/semantic-version-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/setuptools-62.4[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-62.4[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/cffi[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

src_unpack() {
	cargo_src_unpack
}

python_test() {
	local -x UNSAFE_PYO3_SKIP_VERSION_CHECK=1

	local examples=(
		html-py-ever
		namespace_package
		rust_with_cffi
	)
	for example_dir in ${examples[@]}; do
		pushd examples/${example_dir} >/dev/null || die
		einfo "Running ${example_dir} test"
		esetup.py build --build-lib=build/lib

		case ${example_dir} in
			html-py-ever)
				pushd tests >/dev/null || die
				local -x PYTHONPATH=../build/lib
				${EPYTHON} run_all.py || die "Tests failed with ${EPYTHON}"
				popd >/dev/null || die
				;;
			*)
				pushd build/lib >/dev/null || die
				epytest ../../tests
				popd >/dev/null || die
				;;
		esac

		rm -rf build || die
		popd >/dev/null || die
	done
}
