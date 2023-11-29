# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Helping users and developers to get information about the environment"
HOMEPAGE="
	https://gitlab.com/dpizetta/helpdev/
	https://pypi.org/project/helpdev/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pip[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme
distutils_enable_tests pytest
