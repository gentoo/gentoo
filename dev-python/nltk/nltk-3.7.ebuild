# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="sqlite,tk?,xml(+)"

inherit distutils-r1

DESCRIPTION="Natural Language Toolkit"
HOMEPAGE="https://www.nltk.org/ https://github.com/nltk/nltk/"
SRC_URI="https://github.com/nltk/nltk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="tk"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/joblib[${PYTHON_USEDEP}]
		>=dev-python/nltk-data-20211221
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyparsing[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/twython[${PYTHON_USEDEP}]
		sci-libs/scikit-learn[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)"
PDEPEND="dev-python/nltk-data"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	unit/test_downloader.py::test_downloader_using_existing_parent_download_dir
	unit/test_downloader.py::test_downloader_using_non_existing_parent_download_dir
)

src_prepare() {
	# requires unpackaged pycrfsuite
	sed -i -e '/>>>/s@$@ # doctest: +SKIP@' nltk/tag/crf.py || die
	# replace fetching from network with duplicate file URL
	sed -e 's@https://raw.githubusercontent.com/nltk/nltk/develop/nltk/test/toy.cfg@nltk:grammars/sample_grammars/toy.cfg@' \
		-i nltk/test/data.doctest || die

	distutils-r1_src_prepare
}

src_test() {
	cd nltk/test || die
	distutils-r1_src_test
}
