# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{13..15} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

MY_P=${P/_}
DESCRIPTION="Python documentation generator"
HOMEPAGE="
	https://www.sphinx-doc.org/
	https://github.com/sphinx-doc/sphinx/
	https://pypi.org/project/Sphinx/
"
SRC_URI="
	https://github.com/sphinx-doc/sphinx/archive/v${PV/_}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
if [[ ${PV} != *_rc* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi
IUSE="doc latex"

RDEPEND="
	>=dev-python/alabaster-1.0[${PYTHON_USEDEP}]
	>=dev-python/babel-2.18[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.21[${PYTHON_USEDEP}]
	>=dev-python/imagesize-1.3[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1[${PYTHON_USEDEP}]
	>=dev-python/packaging-25.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.19[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.5[${PYTHON_USEDEP}]
	>=dev-python/roman-numerals-3.0[${PYTHON_USEDEP}]
	>=dev-python/snowballstemmer-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-applehelp-1.0.7[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-devhelp-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-htmlhelp-2.0.6[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-jsmath-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-qthelp-1.0.6[${PYTHON_USEDEP}]
	>=dev-python/sphinxcontrib-serializinghtml-1.1.9[${PYTHON_USEDEP}]
	latex? (
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		app-text/dvipng
	)
"
BDEPEND="
	doc? (
		dev-python/sphinxcontrib-websupport[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)
	test? (
		app-text/dvipng
		>=dev-python/cython-3.1[${PYTHON_USEDEP}]
		>=dev-python/defusedxml-0.7.1[${PYTHON_USEDEP}]
		dev-python/pytest-rerunfailures[${PYTHON_USEDEP}]
		>=dev-python/setuptools-80.0[${PYTHON_USEDEP}]
		>=dev-python/typing-extensions-4.15[${PYTHON_USEDEP}]
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-luatex
		virtual/imagemagick-tools[jpeg,png,svg]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
# EPYTEST_XDIST breaks stuff
distutils_enable_tests pytest

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}/sphinx-3.2.1-doc-link.patch"
	)

	distutils-r1_python_prepare_all

	# disable internet access
	sed -i -e 's:^intersphinx_mapping:disabled_&:' \
		doc/conf.py || die
	# unpin dependencies
	sed -i -e 's:,<[0-9.]*::' pyproject.toml || die
}

python_compile_all() {
	# we can't use distutils_enable_sphinx because it would
	# introduce a dep on itself
	use doc && build_sphinx doc
}

python_test() {
	mkdir -p "${BUILD_DIR}/sphinx_tempdir" || die
	local -x SPHINX_TEST_TEMPDIR="${BUILD_DIR}/sphinx_tempdir"

	epytest
}
