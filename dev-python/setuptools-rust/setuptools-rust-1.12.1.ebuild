# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=yes
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

RUST_MIN_VER=1.83.0
CRATES="
	autocfg@1.3.0
	bitflags@2.5.0
	cfg-if@1.0.0
	cssparser-macros@0.6.1
	cssparser@0.36.0
	derive_more-impl@2.1.1
	derive_more@2.1.1
	dtoa-short@0.3.4
	dtoa@1.0.9
	ego-tree@0.10.0
	fastrand@2.3.0
	futf@0.1.5
	getopts@0.2.24
	heck@0.5.0
	html5ever@0.36.1
	itoa@1.0.17
	libc@0.2.154
	lock_api@0.4.12
	log@0.4.21
	mac@0.1.1
	markup5ever@0.36.1
	new_debug_unreachable@1.0.6
	once_cell@1.21.3
	parking_lot@0.12.2
	parking_lot_core@0.9.10
	phf@0.13.1
	phf_codegen@0.13.1
	phf_generator@0.13.1
	phf_macros@0.13.1
	phf_shared@0.13.1
	portable-atomic@1.6.0
	precomputed-hash@0.1.1
	proc-macro2@1.0.106
	proc-macro2@1.0.82
	pyo3-build-config@0.28.2
	pyo3-ffi@0.28.2
	pyo3-macros-backend@0.28.2
	pyo3-macros@0.28.2
	pyo3@0.28.2
	quote@1.0.44
	redox_syscall@0.5.1
	rustc-hash@2.1.1
	rustc_version@0.4.1
	scopeguard@1.2.0
	scraper@0.25.0
	selectors@0.33.0
	semver@1.0.27
	serde@1.0.200
	serde_derive@1.0.200
	servo_arc@0.4.3
	siphasher@1.0.2
	smallvec@1.13.2
	stable_deref_trait@1.2.0
	string_cache@0.9.0
	string_cache_codegen@0.6.1
	syn@2.0.61
	target-lexicon@0.13.4
	target-lexicon@0.13.5
	tendril@0.4.3
	unicode-ident@1.0.12
	unicode-width@0.2.2
	utf-8@0.7.6
	web_atoms@0.2.3
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
	test? (
		${CARGO_CRATE_URIS}
	)
"

# crates are used at test time only, update via pycargoebuild -L -i ...
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	${RUST_DEPEND}
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

export PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

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
