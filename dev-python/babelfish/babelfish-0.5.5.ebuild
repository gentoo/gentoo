# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/Diaoul/babelfish.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit distutils-r1

DESCRIPTION="Python library to work with countries and languages"
HOMEPAGE="https://github.com/Diaoul/babelfish https://pypi.python.org/pypi/babelfish"

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	esetup.py test
}
