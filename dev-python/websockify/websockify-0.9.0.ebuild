# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 )

inherit distutils-r1

SRC_URI="https://github.com/novnc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="WebSockets support for any application/server"
HOMEPAGE="https://github.com/novnc/websockify"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
