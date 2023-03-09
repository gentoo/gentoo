# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python language binding for Selenium Remote Control"
HOMEPAGE="
	https://www.seleniumhq.org/
	https://github.com/SeleniumHQ/selenium/tree/trunk/py/
	https://pypi.org/project/selenium/
"

KEYWORDS="~amd64"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	>=dev-python/certifi-2021.10.8[${PYTHON_USEDEP}]
	<dev-python/trio-1[${PYTHON_USEDEP}]
	>=dev-python/trio-0.17[${PYTHON_USEDEP}]
	<dev-python/trio-websocket-1[${PYTHON_USEDEP}]
	>=dev-python/trio-websocket-0.9[${PYTHON_USEDEP}]
	<dev-python/urllib3-2[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26[${PYTHON_USEDEP}]
"
