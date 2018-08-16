# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy{,3} python{2_7,3_{4,5,6,7}} )

inherit distutils-r1

MY_PN="${PN}3"
DESCRIPTION="Exuberant Ctags indexing python bindings"
HOMEPAGE="https://github.com/jonashaag/python-ctags3"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-util/ctags"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	esetup.py test
}
