# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYPI_VERIFY_REPO=https://github.com/pelican-plugins/minify
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="An HTML minification plugin for Pelican, the static site generator"
HOMEPAGE="
	https://github.com/pelican-plugins/minify/
	https://pypi.org/project/pelican-minify/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=app-text/pelican-4.5[${PYTHON_USEDEP}]
	>=dev-python/minify-html-0.10.8[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
