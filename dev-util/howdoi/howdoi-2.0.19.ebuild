# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS="manual"
PYTHON_COMPAT=( python3_10 )
inherit distutils-r1 pypi

DESCRIPTION="A code search tool"
HOMEPAGE="https://pypi.org/project/howdoi/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
# bug 818580
RESTRICT="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/cachelib[${PYTHON_USEDEP}]
	dev-python/keep[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyquery-1.4.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]
"
