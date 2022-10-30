# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Abydos NLP/IR library"
HOMEPAGE="https://github.com/chrislit/abydos"
SRC_URI="https://github.com/chrislit/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

# Requires access to the internet
RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"

BDEPEND="test? (
	dev-python/nltk[${PYTHON_USEDEP}]
)"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.10.patch"
)

distutils_enable_tests pytest
# Extension error: You must configure the bibtex_bibfiles setting
#distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/sphinxcontrib-bibtex

python_prepare_all() {
	# do not depend on pytest-cov
	sed -i -e '/addopts/d' setup.cfg || die

	distutils-r1_python_prepare_all
}
