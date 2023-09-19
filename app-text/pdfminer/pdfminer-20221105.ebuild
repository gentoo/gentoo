# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )
inherit distutils-r1

MY_P="${PN}.six-${PV}"
DESCRIPTION="Python tool for extracting information from PDF documents"
HOMEPAGE="https://pdfminersix.readthedocs.io/en/latest/"
# Release tarballs lack tests
SRC_URI="https://github.com/pdfminer/pdfminer.six/archive/refs/tags/${PV}.tar.gz -> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=">=dev-python/charset-normalizer-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-36.0.0[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs "dev-python/sphinx-argparse"
distutils_enable_tests pytest

python_prepare_all() {
	sed -i -e "s:__VERSION__:${PV}:g" pdfminer/__init__.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	# Non-standard doc generation
	if use doc; then
		PYTHONPATH="${PYTHONPATH}:${BUILD_DIR}/install" sphinx-build docs/source "${WORKDIR}"/_docs
		HTML_DOCS=( "${WORKDIR}"/_docs/. )
	fi
}

python_install_all() {
	use examples && dodoc -r samples
	distutils-r1_python_install_all
}
