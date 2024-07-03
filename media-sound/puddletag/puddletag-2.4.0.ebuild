# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11,12} )

inherit distutils-r1 xdg

DESCRIPTION="Audio tag editor"
HOMEPAGE="https://docs.puddletag.net/"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acoustid quodlibet"

RDEPEND="
	>=dev-python/configobj-5.0.8[${PYTHON_USEDEP}]
	>=dev-python/Levenshtein-0.25.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-5.2.2[${PYTHON_USEDEP}]
	acoustid? ( >=dev-python/pyacoustid-1.3.0[${PYTHON_USEDEP}] )
	>=dev-python/pyparsing-3.1.2[${PYTHON_USEDEP}]
	>=dev-python/PyQt5-5.15.10[${PYTHON_USEDEP},svg]
	>=dev-python/unidecode-1.3.8[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.47.0[${PYTHON_USEDEP}]
	quodlibet? ( >=media-sound/quodlibet-4.4.0[${PYTHON_USEDEP}] )
"
DOCS=(changelog NEWS THANKS TODO)
