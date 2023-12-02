# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A patch parsing and application library."
HOMEPAGE="
	https://github.com/cscorley/whatthepatch/
	https://pypi.org/project/whatthepatch/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"

distutils_enable_tests pytest
