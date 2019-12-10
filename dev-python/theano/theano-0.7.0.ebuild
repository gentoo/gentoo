# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

MYPN=Theano
MYP=${MYPN}-$(replace_version_separator 3 '')

DESCRIPTION="Define and optimize multi-dimensional arrays mathematical expressions"
HOMEPAGE="https://github.com/Theano/Theano"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

SLOT="0"
LICENSE="BSD"
IUSE="test"
RESTRICT="!test? ( test )"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/numpy-1.6.2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.11[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYP}"

python_prepare_all() {
	find -type f -name "*.py" -exec \
	sed \
		-e 's:theano.compat.six:six:g' \
		-i '{}' + || die

	rm ${PN}/compat/six.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbosity=3 || die
}
