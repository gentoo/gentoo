# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{9..11} )
inherit distutils-r1 pypi

DESCRIPTION="Preview GitHub Markdown files like Readme locally before committing them"
HOMEPAGE="https://github.com/joeyespo/grip"
LICENSE="MIT"

SLOT="0"

KEYWORDS="amd64"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!media-sound/grip
	>=dev-python/docopt-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/path-and-address-2.0.1[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4.1[${PYTHON_USEDEP}]
"
