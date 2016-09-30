# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

SRC_URI="https://github.com/kanaka/${PN}/archive/v${PV}.zip -> ${P}.zip"
DESCRIPTION="WebSockets support for any application/server"
HOMEPAGE="https://github.com/kanaka/websockify"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
