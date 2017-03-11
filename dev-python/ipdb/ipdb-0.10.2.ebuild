# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="IPython-enabled pdb"
HOMEPAGE="https://pypi.python.org/pypi/ipdb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/ipython[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/backports-shutil_get_terminal_size[${PYTHON_USEDEP}]' python2_7)
	"

DOCS=( HISTORY.txt )

python_test() {
	esetup.py test
}
