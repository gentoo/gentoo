# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A lightweight YAML Parser for Python"
HOMEPAGE="
	https://github.com/hackebrot/poyo/
	https://pypi.org/project/poyo/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

distutils_enable_tests pytest
