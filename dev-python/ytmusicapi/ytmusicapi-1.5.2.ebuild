# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Unofficial API for YouTube Music"
HOMEPAGE="https://ytmusicapi.readthedocs.io/
	https://github.com/sigma67/ytmusicapi/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
RESTRICT="test"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs/source \
	dev-python/sphinx-rtd-theme
