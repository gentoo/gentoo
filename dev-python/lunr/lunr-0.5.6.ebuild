# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A Python implementation of Lunr.js"
HOMEPAGE="https://github.com/yeraydiazdiaz/lunr.py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/nltk[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

DEPEND="test? (
	dev-python/mock[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest

python_prepare_all() {
	# No such file or directory: '/var/tmp/portage/dev-python/lunr-0.5.6/work/lunr-0.5.6/tests/fixtures/stemming_vocab.json'
	# file missing in pypi release tarball
	sed -i -e 's:test_reduces_words_to_their_stem:_&:' tests/test_stemmer.py || die

	distutils-r1_python_prepare_all
}
