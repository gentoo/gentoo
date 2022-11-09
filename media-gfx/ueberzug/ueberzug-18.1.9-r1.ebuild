# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Command line util to draw images on terminals by using child windows"
HOMEPAGE="https://github.com/seebye/ueberzug/"
SRC_URI="mirror://pypi/${P::1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEPEND="
	x11-libs/libX11
	x11-libs/libXext"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/python-xlib[${PYTHON_USEDEP}]"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto"
