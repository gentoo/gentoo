# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1
distutils_enable_tests unittest

MY_PV="${PV/_p/.post}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="A zero-boilerplate games programming framework based on Pygame"
HOMEPAGE="https://pygame-zero.readthedocs.io/"
SRC_URI="https://github.com/lordmauve/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
"

S="${WORKDIR}/${MY_P}"

# Allow the tests to pass without real audio or video.
export SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=dummy
