# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} pypy3 )
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
IUSE="test"
RESTRICT="!test? ( test )"

# Tests for python2.7 ran fine even with dev-python/markdown-2.6.5,
# but only python3.7 is supported with $PV >= 3.x.
DEPEND="
	>=dev-python/markdown-3.0.1[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND=""

python_test() {
	esetup.py test
}
