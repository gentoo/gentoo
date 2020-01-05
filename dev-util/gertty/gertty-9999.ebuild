# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_6 python3_7 )

inherit distutils-r1

DESCRIPTION="Gertty is a console-based interface to the Gerrit Code Review system."
HOMEPAGE="https://pypi.org/project/gertty/"
if [[ ${PV} == *9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://opendev.org/ttygroup/gertty"
	EGIT_BRANCH="master"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

CDEPEND=">=dev-python/pbr-0.11[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/urwid-1.2.1[${PYTHON_USEDEP}]
	!~dev-python/urwid-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.0.4[${PYTHON_USEDEP}]
	>=dev-python/git-python-0.3.7[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.3[${PYTHON_USEDEP}]
	<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/ordereddict[${PYTHON_USEDEP}]' 'python2*')
	>=dev-python/alembic-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.7[${PYTHON_USEDEP}]
	>=dev-python/ply-3.4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
