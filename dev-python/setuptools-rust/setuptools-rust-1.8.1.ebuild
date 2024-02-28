# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

CRATES="
	autocfg@1.1.0
	bitflags@1.3.2
	byteorder@1.4.3
	cfg-if@1.0.0
	convert_case@0.4.0
	cssparser-macros@0.6.0
	cssparser@0.27.2
	derive_more@0.99.17
	dtoa-short@0.3.3
	dtoa@0.4.8
	futf@0.1.5
	fxhash@0.2.1
	getrandom@0.1.16
	heck@0.4.1
	html5ever@0.25.1
	indoc@1.0.9
	indoc@2.0.4
	instant@0.1.12
	itoa@0.4.8
	kuchiki@0.8.1
	lazy_static@1.4.0
	libc@0.2.121
	libc@0.2.147
	lock_api@0.4.10
	lock_api@0.4.6
	log@0.4.14
	mac@0.1.1
	markup5ever@0.10.1
	matches@0.1.9
	memoffset@0.9.0
	new_debug_unreachable@1.0.4
	nodrop@0.1.14
	once_cell@1.10.0
	once_cell@1.18.0
	parking_lot@0.11.2
	parking_lot@0.12.1
	parking_lot_core@0.8.5
	parking_lot_core@0.9.8
	phf@0.8.0
	phf_codegen@0.8.0
	phf_generator@0.8.0
	phf_macros@0.8.0
	phf_shared@0.10.0
	phf_shared@0.8.0
	ppv-lite86@0.2.16
	precomputed-hash@0.1.1
	proc-macro-hack@0.5.19
	proc-macro2@1.0.66
	proc-macro2@1.0.69
	pyo3-build-config@0.19.2
	pyo3-build-config@0.20.0
	pyo3-ffi@0.19.2
	pyo3-ffi@0.20.0
	pyo3-macros-backend@0.19.2
	pyo3-macros-backend@0.20.0
	pyo3-macros@0.19.2
	pyo3-macros@0.20.0
	pyo3@0.19.2
	pyo3@0.20.0
	quote@1.0.32
	quote@1.0.33
	rand@0.7.3
	rand_chacha@0.2.2
	rand_core@0.5.1
	rand_hc@0.2.0
	rand_pcg@0.2.1
	redox_syscall@0.2.11
	redox_syscall@0.3.5
	rustc_version@0.4.0
	scopeguard@1.1.0
	scopeguard@1.2.0
	selectors@0.22.0
	semver@1.0.6
	serde@1.0.136
	servo_arc@0.1.1
	siphasher@0.3.10
	smallvec@1.11.0
	smallvec@1.8.0
	stable_deref_trait@1.2.0
	string_cache@0.8.3
	string_cache_codegen@0.5.1
	syn@1.0.109
	syn@1.0.89
	syn@2.0.32
	syn@2.0.38
	target-lexicon@0.12.11
	target-lexicon@0.12.3
	tendril@0.4.3
	thin-slice@0.1.1
	unicode-ident@1.0.11
	unicode-ident@1.0.12
	unicode-xid@0.2.2
	unindent@0.1.11
	unindent@0.2.3
	utf-8@0.7.6
	wasi@0.9.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-targets@0.48.1
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.0
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.0
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.0
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.0
	windows_x86_64_msvc@0.48.5
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
KEYWORDS="amd64 arm arm64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
# pyo3 < 0.20.3 is broken on ppc; https://bugs.gentoo.org/918970
RESTRICT="
	!test? ( test )
	ppc? ( test )
"
[[ ${CRATES} != *pyo3@0.20.0* ]] && die "Please recheck ppc test restriction"

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
