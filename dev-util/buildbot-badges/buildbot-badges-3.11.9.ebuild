# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_REQ_USE="sqlite"
PYTHON_COMPAT=( python3_{10..12} )
PYPI_PN=${PN/-/_}
inherit distutils-r1 pypi

DESCRIPTION="Buildbot badges plugin produces an image in SVG or PNG format..."
HOMEPAGE="https://buildbot.net/
	https://github.com/buildbot/buildbot
	https://pypi.org/project/buildbot-grid-view/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~amd64-linux ~x86-linux"

BDEPEND="
	~dev-util/buildbot-${PV}[${PYTHON_USEDEP}]
	~dev-util/buildbot-www-${PV}[${PYTHON_USEDEP}]
	~dev-util/buildbot-pkg-${PV}[${PYTHON_USEDEP}]
	dev-python/cairocffi[${PYTHON_USEDEP}]
	media-gfx/cairosvg[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.1[${PYTHON_USEDEP}]
	dev-python/klein[${PYTHON_USEDEP}]
"
