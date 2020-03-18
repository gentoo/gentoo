# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_USE_SETUPTOOLS="rdepend"

inherit distutils-r1

DESCRIPTION="A little word cloud generator in Python"
HOMEPAGE="https://amueller.github.io/word_cloud/"
SRC_URI="https://github.com/amueller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	media-fonts/droid"

PATCHES=( "${FILESDIR}"/${P}-bundled-font.patch )
