# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Unofficial API for YouTube Music"
HOMEPAGE="https://ytmusicapi.readthedocs.io/"
SRC_URI="https://github.com/sigma67/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme
