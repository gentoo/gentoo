# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite,tk?,xml(+)"

inherit distutils-r1

DESCRIPTION="Natural Language Toolkit"
HOMEPAGE="https://www.nltk.org/ https://github.com/nltk/nltk/"
SRC_URI="https://github.com/nltk/nltk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="tk"

RDEPEND="
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/joblib[${PYTHON_USEDEP}]
		>=dev-python/nltk-data-20200312-r1
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pyparsing[${PYTHON_USEDEP}]
		dev-python/twython[${PYTHON_USEDEP}]
		sci-libs/scikits_learn[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)"
PDEPEND="dev-python/nltk-data"

distutils_enable_tests nose

src_prepare() {
	# requires unpackaged pycrfsuite
	sed -i -e '/>>>/s@$@ # doctest: +SKIP@' nltk/tag/crf.py || die
	# replace fetching from network with duplicate file URL
	sed -e 's@https://raw.githubusercontent.com/nltk/nltk/develop/nltk/test/toy.cfg@nltk:grammars/sample_grammars/toy.cfg@' \
		-i nltk/test/data.doctest || die
	# requires X and hangs in Xvfb
	sed -e 's:test_plot:_&:' \
		-i nltk/test/unit/test_cfd_mutation.py || die

	distutils-r1_src_prepare
}

src_test() {
	cd nltk/test || die
	distutils-r1_src_test
}

python_test() {
	"${EPYTHON}" runtests.py -v || die "Tests failed with ${EPYTHON}"
}
