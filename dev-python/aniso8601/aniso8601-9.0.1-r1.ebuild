# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="A library for parsing ISO 8601 strings"
HOMEPAGE="https://bitbucket.org/nielsenb/aniso8601/ https://pypi.org/project/aniso8601/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND=">=dev-python/python-dateutil-2.7.3[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
