# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="Command line util to draw images on terminals by using child windows"
HOMEPAGE="https://github.com/ueber-devel/ueberzug/"
SRC_URI="
	https://github.com/ueber-devel/ueberzug/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXres
"
RDEPEND="
	${COMMON_DEPEND}
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	!media-gfx/ueberzugpp
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"

distutils_enable_tests import-check
