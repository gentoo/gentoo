# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

CARGO_OPTIONAL=1
CRATES="
	autocfg@1.5.0
	heck@0.5.0
	indoc@2.0.7
	libc@0.2.177
	memoffset@0.9.1
	once_cell@1.21.3
	portable-atomic@1.11.1
	proc-macro2@1.0.103
	pyo3-build-config@0.27.1
	pyo3-ffi@0.27.1
	pyo3-macros-backend@0.27.1
	pyo3-macros@0.27.1
	pyo3@0.27.1
	quote@1.0.42
	rustversion@1.0.22
	syn@2.0.111
	target-lexicon@0.13.3
	unicode-ident@1.0.22
	unindent@0.2.4
"

inherit cargo distutils-r1

DESCRIPTION="A logging replacement for Python"
HOMEPAGE="
	https://logbook.readthedocs.io/en/stable/
	https://github.com/getlogbook/logbook/
	https://pypi.org/project/Logbook/
"
SRC_URI="
	https://github.com/getlogbook/logbook/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	native-extensions? (
		${CARGO_CRATE_URIS}
	)
"

LICENSE="BSD"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"
IUSE="+native-extensions"

RDEPEND="
	>=dev-python/typing-extensions-4.14.0[${PYTHON_USEDEP}]
"
BDEPEND="
	native-extensions? (
		${RUST_DEPEND}
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	)
	test? (
		>=app-arch/brotli-1.1.0[${PYTHON_USEDEP},python]
		>=dev-python/execnet-1.5[${PYTHON_USEDEP}]
		>=dev-python/jinja2-2.11.3[${PYTHON_USEDEP}]
		dev-python/pip[${PYTHON_USEDEP}]
		>=dev-python/pyzmq-27.0.2[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
	)
"
EPYTEST_PLUGINS=( pytest-rerunfailures )
distutils_enable_tests pytest
distutils_enable_sphinx docs

EPYTEST_DESELECT=(
	# Delete test file requiring local connection to redis server
	tests/test_queues.py
)

QA_FLAGS_IGNORED="usr/lib.*/py.*/site-packages/logbook/_speedups.*.so"

src_unpack() {
	default
	use native-extensions && cargo_src_unpack
}

python_configure_all() {
	if ! use native-extensions; then
		export DISABLE_LOGBOOK_CEXT=1
	fi
}
