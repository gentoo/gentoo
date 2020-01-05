# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} pypy3 )
inherit distutils-r1

MY_PN="python-${PN}"

DESCRIPTION="Math extension for Python-Markdown"
HOMEPAGE="https://github.com/mitya57/python-markdown-math"

if [[ ${PV} == **9999 ]]
	then
		inherit git-r3
		EGIT_REPO_URI="https://github.com/mitya57/python-markdown-math.git"
else
		SRC_URI="mirror://pypi/${MY_PN:0:1}/${PN}/${P}.tar.gz"
		KEYWORDS="amd64 x86"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

# Tests for python2.7 ran fine even with dev-python/markdown-2.6.5,
# but python3.7 is only supported from 3.x onwards.
DEPEND="
	>=dev-python/markdown-3.0.1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

python_test(){
	esetup.py test
}
