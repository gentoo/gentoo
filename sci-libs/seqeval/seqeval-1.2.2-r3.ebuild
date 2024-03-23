# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Python framework for sequence labeling evaluation"
HOMEPAGE="
	https://pypi.org/project/seqeval/
	https://github.com/chakki-works/seqeval
"
SRC_URI="https://github.com/chakki-works/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
"
BDEPEND="test? (
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
	distutils-r1_src_compile
}

src_test() {
	cd tests
	distutils-r1_src_test
}
