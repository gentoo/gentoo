# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# 'Programming Language :: ...  in setup.py requires updating"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

MY_PN="json_tools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A set of tools to manipulate JSON: diff, patch, and pretty-printing"
HOMEPAGE="https://pypi.python.org/pypi/json_tools https://bitbucket.org/vadim_semenov/json_tools"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}
