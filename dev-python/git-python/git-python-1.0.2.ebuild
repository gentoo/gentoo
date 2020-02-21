# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

MY_PN="GitPython"
MY_PV="${PV/_rc/.RC}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Library used to interact with Git repositories"
HOMEPAGE="https://github.com/gitpython-developers/GitPython https://pypi.org/project/GitPython/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

# Tests dont make sense without a git repo
RESTRICT="test"

RDEPEND="
	dev-vcs/git
	 >=dev-python/gitdb-0.6.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"
# $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
# is the correct entry for mock, however while RESTRICT="test"
# there is little point in setting it since it is inactive
S="${WORKDIR}/${MY_P}"
