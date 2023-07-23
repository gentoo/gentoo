# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 virtualx

DESCRIPTION="Python interface to the mpv media player"
HOMEPAGE="
	https://github.com/jaseg/python-mpv/
	https://pypi.org/project/python-mpv/
"
SRC_URI="
	https://github.com/jaseg/python-mpv/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-video/mpv[libmpv]
	dev-python/pillow[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pyvirtualdisplay[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	virtx epytest
}
