# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_10 )
inherit distutils-r1 pypi

DESCRIPTION="BuildBot base web interface, use with buildbot-{console-view,waterfall-view}..."
HOMEPAGE="https://buildbot.net/
	https://github.com/buildbot/buildbot
	https://pypi.org/project/buildbot-www/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~amd64-linux ~x86-linux"

RDEPEND="~dev-util/buildbot-pkg-${PV}[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}"
