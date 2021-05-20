# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1 virtualx

DESCRIPTION="Python interface to the mpv media player"
HOMEPAGE="https://github.com/jaseg/python-mpv"
SRC_URI="https://github.com/jaseg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-video/mpv[libmpv]
	dev-python/pillow[${PYTHON_USEDEP}]
"

BDEPEND="test? ( dev-python/xvfbwrapper[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_test() {
	virtx pytest -vv
}
