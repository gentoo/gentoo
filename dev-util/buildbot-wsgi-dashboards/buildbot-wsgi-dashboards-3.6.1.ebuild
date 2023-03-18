# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_10 )
inherit distutils-r1 pypi

DESCRIPTION="Buildbot plugin to integrate flask or bottle dashboards to buildbot UI"
HOMEPAGE="https://buildbot.net/
	https://github.com/buildbot/buildbot
	https://pypi.org/project/buildbot-wsgi-dashboards/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~amd64-linux ~x86-linux"

BDEPEND="
	~dev-util/buildbot-${PV}[${PYTHON_USEDEP}]
	~dev-util/buildbot-www-${PV}[${PYTHON_USEDEP}]
"
