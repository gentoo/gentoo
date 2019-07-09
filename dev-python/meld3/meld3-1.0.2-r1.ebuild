# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5} pypy )

inherit distutils-r1

DESCRIPTION="meld3 is an HTML/XML templating engine"
HOMEPAGE="https://github.com/supervisor/meld3 https://pypi.org/project/meld3/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
