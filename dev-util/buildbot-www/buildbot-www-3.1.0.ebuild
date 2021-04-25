# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS="bdepend"

inherit distutils-r1

DESCRIPTION="BuildBot base web interface, use with buildbot-{console-view,waterfall-view}..."
HOMEPAGE="https://buildbot.net/ https://github.com/buildbot/buildbot https://pypi.org/project/buildbot-www/"

MY_PV="${PV/_p/.post}"
MY_P="${PN}-${MY_PV}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

DEPEND="
	~dev-util/buildbot-pkg-${PV}[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
