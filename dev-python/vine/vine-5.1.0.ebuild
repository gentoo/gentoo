# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Python Promises"
HOMEPAGE="
	https://github.com/celery/vine/
	https://pypi.org/project/vine/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/celery/vine/pull/105
	"${FILESDIR}/${P}-pytest-8.patch"
)
