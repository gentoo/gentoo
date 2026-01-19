# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/jelmer/dulwich
PYTHON_COMPAT=( python3_{11..14} )

CRATES="
	autocfg@1.5.0
	heck@0.5.0
	indoc@2.0.7
	libc@0.2.177
	memchr@2.7.6
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.103
	pyo3-build-config@0.27.2
	pyo3-ffi@0.27.2
	pyo3-macros-backend@0.27.2
	pyo3-macros@0.27.2
	pyo3@0.27.2
	quote@1.0.42
	rustversion@1.0.22
	similar@2.7.0
	syn@2.0.110
	target-lexicon@0.13.3
	unicode-ident@1.0.22
	unindent@0.2.4
"

inherit cargo distutils-r1 pypi

DESCRIPTION="Pure-Python implementation of the Git file formats and protocols"
HOMEPAGE="
	https://github.com/jelmer/dulwich/
	https://pypi.org/project/dulwich/
"
SRC_URI+="
	native-extensions? (
		${CARGO_CRATE_URIS}
	)
"

LICENSE="GPL-2+ Apache-2.0"
LICENSE+=" native-extensions? ("
# Dependent crate licenses
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
LICENSE+=" )"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 x86"
IUSE="doc examples +native-extensions test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/urllib3-2.2.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/typing-extensions-4.0[${PYTHON_USEDEP}]
	' 3.11)
"
BDEPEND="
	native-extensions? (
		${RUST_DEPEND}
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/fastimport[${PYTHON_USEDEP}]
		dev-python/gpgmepy[${PYTHON_USEDEP}]
		dev-python/merge3[${PYTHON_USEDEP}]
		dev-python/paramiko[${PYTHON_USEDEP},server(+)]
	)
"

distutils_enable_sphinx docs

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/dulwich/_.*.so"

pkg_setup() {
	# avoid rust_pkg_setup which will die when there's no Rust found
	if use native-extensions ; then
		rust_pkg_setup  # implicitly inherited through cargo
	fi
}

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}

python_compile() {
	# make extension build errors fatal
	local -x CIBUILDWHEEL=1
	unset PURE
	if ! use native-extensions; then
		local -x PURE=1
	fi

	distutils-r1_python_compile
}

python_test() {
	# remove interference from the tests that do stuff like user.name
	unset GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_AUTHOR_DATE
	unset GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL GIT_COMMITTER_DATE
	unset EMAIL
	# Do not use make check which rebuilds the extension and uses -Werror,
	# causing unexpected failures.
	"${EPYTHON}" -m unittest -v tests.test_suite ||
		die "tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi
	distutils-r1_python_install_all
}
