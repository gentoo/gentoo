# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Utities to validate Tavern responses"
HOMEPAGE="
	https://github.com/sohoffice/tavalidate/
	https://pypi.org/project/tavalidate/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/lxml-4.0.0[${PYTHON_USEDEP}]
	dev-python/python-box[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
