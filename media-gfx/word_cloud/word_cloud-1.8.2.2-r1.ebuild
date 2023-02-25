# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10,11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A little word cloud generator in Python"
HOMEPAGE="https://amueller.github.io/word_cloud/"
SRC_URI="https://github.com/amueller/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~ulm/distfiles/${P}-python-3.11.patch.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"  #808150

RDEPEND="dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	media-fonts/droid"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.0-bundled-font.patch
	"${WORKDIR}"/${P}-python-3.11.patch
)
