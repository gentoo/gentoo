# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="sqlite,tk?,xml(+)"

inherit distutils-r1

DESCRIPTION="Natural Language Toolkit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="https://www.nltk.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="numpy test tk"

RDEPEND="numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

# currently requires linguistic data to be downloaded separately
RESTRICT="test"

python_test() {
	nosetests || die "Tests failed under ${EPYTHON}"
}
