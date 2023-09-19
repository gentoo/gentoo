# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Abydos NLP/IR library"
HOMEPAGE="
	https://github.com/chrislit/abydos/
	https://pypi.org/project/abydos/
"
SRC_URI="
	https://github.com/chrislit/abydos/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/deprecation[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-fix-py3.10.patch"
)

distutils_enable_tests pytest
# Extension error: You must configure the bibtex_bibfiles setting
#distutils_enable_sphinx docs dev-python/sphinx-rtd-theme dev-python/sphinxcontrib-bibtex

EPYTEST_DESELECT=(
	# Internet
	tests/distance/test_distance_meta_levenshtein.py::MetaLevenshteinTestCases::test_meta_levenshtein_corpus
	tests/distance/test_distance_softtf_idf.py::SoftTFIDFTestCases::test_softtf_idf_corpus
	tests/distance/test_distance_tf_idf.py::TFIDFTestCases::test_tf_idf_corpus
	tests/util/test_data.py::DataTestCases::test_data
)

python_prepare_all() {
	# do not depend on pytest-cov
	sed -i -e '/addopts/d' setup.cfg || die

	distutils-r1_python_prepare_all
}
