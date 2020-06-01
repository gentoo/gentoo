# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

DESCRIPTION="BuildBot grid view web interface"
HOMEPAGE="https://buildbot.net/ https://github.com/buildbot/buildbot https://pypi.org/project/buildbot-grid-view/"

MY_PV="${PV/_p/.post}"
MY_P="${PN}-${MY_PV}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
	~dev-util/buildbot-${PV}[${PYTHON_USEDEP}]
	~dev-util/buildbot-www-${PV}[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	distutils-r1_python_install_all
}
