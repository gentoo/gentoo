# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )
inherit distutils-r1

MY_PV="${PV/_p/.post}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A zero-boilerplate games programming framework based on Pygame"
HOMEPAGE="https://pygame-zero.readthedocs.io/"
SRC_URI="https://github.com/lordmauve/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pygame[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		media-libs/sdl2-image[png]
		media-libs/sdl2-mixer[vorbis]
	)
"
distutils_enable_tests unittest

python_test() {
	# Allow the tests to pass without real audio or video.
	local -x SDL_AUDIODRIVER=dummy SDL_VIDEODRIVER=dummy
	eunittest
}
