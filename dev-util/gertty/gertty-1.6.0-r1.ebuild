# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Gertty is a console-based interface to the Gerrit Code Review system"
HOMEPAGE="https://pypi.org/project/gertty/"
if [[ ${PV} == *9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://opendev.org/ttygroup/gertty"
	EGIT_BRANCH="master"
else
	inherit pypi
	KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-python/pbr-0.11[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/pbr-0.11[${PYTHON_USEDEP}]
	>=dev-python/urwid-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.0.4[${PYTHON_USEDEP}]
	>=dev-python/GitPython-0.3.7[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.3[${PYTHON_USEDEP}]
	<dev-python/requests-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/alembic-0.6.4[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/voluptuous-0.7[${PYTHON_USEDEP}]
	>=dev-python/ply-3.4[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
