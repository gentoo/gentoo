# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8,9,10} )

inherit distutils-r1 xdg

DESCRIPTION="Audio tag editor"
HOMEPAGE="http://docs.puddletag.net/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acoustid quodlibet"

DEPEND=""
RDEPEND="
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.15.6[${PYTHON_USEDEP},svg]
	>=media-libs/mutagen-1.45.1[${PYTHON_USEDEP}]
	acoustid? ( >=media-libs/chromaprint-1.5.0 )
	quodlibet? ( >=media-sound/quodlibet-4.4.0[${PYTHON_USEDEP}] )
	>=dev-python/sip-4.19.22:0[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.9.1[${PYTHON_USEDEP}]
"
DOCS=(changelog NEWS THANKS TODO)
