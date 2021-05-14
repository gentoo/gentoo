# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS=rdepend
DISTUTILS_IN_SOURCE_BUILD=1

CARGO_OPTIONAL=yes

inherit distutils-r1 cargo

MY_PN="${PN/_/-}"
MY_P="${MY_PN}-${PV}"

TEST_CRATES="
bitflags-1.2.1
byteorder-1.3.4
cfg-if-0.1.10
cloudabi-0.1.0
cssparser-0.27.2
cssparser-macros-0.6.0
ctor-0.1.15
derive_more-0.99.10
dtoa-0.4.6
dtoa-short-0.3.2
futf-0.1.4
fxhash-0.2.1
getrandom-0.1.15
ghost-0.1.2
html5ever-0.25.1
indoc-0.3.6
indoc-impl-0.3.6
instant-0.1.6
inventory-0.1.9
inventory-impl-0.1.9
itoa-0.4.6
kuchiki-0.8.1
lazy_static-1.4.0
libc-0.2.77
lock_api-0.4.1
log-0.4.11
mac-0.1.1
markup5ever-0.10.0
matches-0.1.8
new_debug_unreachable-1.0.4
nodrop-0.1.14
parking_lot-0.11.0
parking_lot_core-0.8.0
paste-0.1.18
paste-impl-0.1.18
phf-0.8.0
phf_codegen-0.8.0
phf_generator-0.8.0
phf_macros-0.8.0
phf_shared-0.8.0
ppv-lite86-0.2.9
precomputed-hash-0.1.1
proc-macro-hack-0.5.18
proc-macro2-1.0.21
pyo3-0.12.1
pyo3-derive-backend-0.12.1
pyo3cls-0.12.1
quote-1.0.7
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.5.1
rand_hc-0.2.0
rand_pcg-0.2.1
redox_syscall-0.1.57
ryu-1.0.5
scopeguard-1.1.0
selectors-0.22.0
serde-1.0.116
serde_derive-1.0.116
serde_json-1.0.57
servo_arc-0.1.1
siphasher-0.3.3
smallvec-1.4.2
stable_deref_trait-1.2.0
string_cache-0.8.0
string_cache_codegen-0.5.1
syn-1.0.41
tendril-0.4.1
thin-slice-0.1.1
unicode-xid-0.2.1
unindent-0.1.6
utf-8-0.7.5
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

DESCRIPTION="a plugin for setuptools to build Rust Python extensions"
HOMEPAGE="https://github.com/PyO3/setuptools-rust"
SRC_URI="mirror://pypi/${PN::1}/${MY_PN}/${MY_P}.tar.gz
	test? ( $(cargo_crate_uris ${TEST_CRATES}) )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/rust-1.41.0
	dev-python/semantic_version[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	cargo_src_unpack
}

python_test() {
	distutils_install_for_testing

	# rust_with_cffi - needs a different version of pyo3
	local examples=(html-py-ever tomlgen namespace_package)
	for example_dir in ${examples[@]}; do
		pushd examples/${example_dir} || die

		einfo "Running ${example_dir} test"

		case ${example_dir} in
			tomlgen)
				# tomlgen tests toml generation
				esetup.py tomlgen_rust
				;;
			html-py-ever)
				esetup.py build

				pushd test || die
				${EPYTHON} run_all.py || die "Tests failed with ${EPYTHON}"
				popd || die
				;;
			*)
				esetup.py build
				epytest
				;;
		esac

		popd || die

		if [ ${example_dir} != "tomlgen" ]; then
			# clean up the built example
			rm -r build/lib/${example_dir//-/_} || die
		fi
	done
}
