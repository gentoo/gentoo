# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx theme for aiohttp"
HOMEPAGE="
	https://github.com/aio-libs/aiohttp-theme/
	https://pypi.org/project/aiohttp-theme/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-python/sphinx[${PYTHON_USEDEP}]
"
