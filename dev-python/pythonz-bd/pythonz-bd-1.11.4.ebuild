# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{6,7}} pypy3 )

inherit distutils-r1

DESCRIPTION="Manage python installations in your system, berdario's shallow fork"
HOMEPAGE="
	https://github.com/berdario/pythonz/tree/bd
	https://pypi.org/project/pythonz-bd/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/resumable-urlretrieve[${PYTHON_USEDEP}]' 'python3*')"
