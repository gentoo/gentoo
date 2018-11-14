# Copyright 1999-2016 Gentoo Foundation
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
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYP}"

python_test() {
	nosetests --verbosity=3 || die
}
