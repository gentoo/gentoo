# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="An HTML minification plugin for Pelican, the static site generator"
HOMEPAGE="
	https://github.com/pelican-plugins/minify/
	https://pypi.org/project/pelican-minify/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-text/pelican-4.5[${PYTHON_USEDEP}]
	>=dev-python/minify-html-0.10.8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/pelican-plugins/minify/pull/3
	"${FILESDIR}/${P}-hatchling.patch"
)
