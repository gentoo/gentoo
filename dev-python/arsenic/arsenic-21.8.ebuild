# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Asynchronous WebDriver client"
HOMEPAGE="https://github.com/HENNGE/arsenic"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/aiohttp[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
