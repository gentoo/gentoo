# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Library for creating and manipulating HTML documents using an elegant DOM API"
HOMEPAGE="
	https://github.com/Knio/dominate/
	https://pypi.org/project/dominate/
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/Knio/dominate/pull/202
	"${FILESDIR}/${P}-py313.patch"
)
