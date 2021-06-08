# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1 xdg

DESCRIPTION="Audio tag editor"
HOMEPAGE="http://docs.puddletag.net/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acoustid quodlibet"

DEPEND=""
RDEPEND="
	>=dev-python/configobj-5.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.4.7[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.15.2[${PYTHON_USEDEP},svg]
	>=media-libs/mutagen-1.45.1[${PYTHON_USEDEP}]
	acoustid? ( >=media-libs/chromaprint-1.4.3 )
	quodlibet? ( >=media-sound/quodlibet-4.3.0[${PYTHON_USEDEP}] )
	>=dev-python/sip-4.19.22:0[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.5.2[${PYTHON_USEDEP}]
"
# docs
#	>=dev-python/wheel-0.35.1[${PYTHON_USEDEP}]
#	>=dev-python/markdown-3.1.1[${PYTHON_USEDEP}]
#	>=dev-python/sphinx-1.4.8[${PYTHON_USEDEP}]
#	>=dev-python/sphinx-bootstrap-theme-0.4.13[${PYTHON_USEDEP}]
#	>=dev-python/PyRSS2Gen-1.1[${PYTHON_USEDEP}]

DOCS=(changelog NEWS THANKS TODO)
