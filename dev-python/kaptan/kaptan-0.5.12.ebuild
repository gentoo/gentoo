# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="Configuration manager in your pocket"
HOMEPAGE="https://github.com/emre/kaptan"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="kaptan"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${BDEPEND}
	test? (	>=dev-python/pytest-4.4.1[${PYTHON_USEDEP}] )"
RDEPEND="${BDEPEND}
	>=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
