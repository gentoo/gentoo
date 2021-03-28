# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS="bdepend"

inherit distutils-r1

DESCRIPTION="Buildbot badges plugin produces an image in SVG or PNG format..."
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
	~dev-util/buildbot-pkg-${PV}[${PYTHON_USEDEP}]
	dev-python/cairocffi[${PYTHON_USEDEP}]
	media-gfx/cairosvg[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.1[${PYTHON_USEDEP}]
	dev-python/klein[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"
