# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_12 )
inherit distutils-r1 pypi

DESCRIPTION="BuildBot react based grid view web interface"
HOMEPAGE="https://buildbot.net/
	https://github.com/buildbot/buildbot
	https://pypi.org/project/buildbot-react-grid-view/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	~dev-util/buildbot-${PV}[${PYTHON_USEDEP}]
	~dev-util/buildbot-www-react-${PV}[${PYTHON_USEDEP}]
"
