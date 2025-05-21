# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Patch built-in Python objects"
HOMEPAGE="
	https://github.com/clarete/forbiddenfruit/
	https://pypi.org/project/forbiddenfruit/
"

LICENSE="|| ( GPL-3 MIT )"
SLOT="0"
KEYWORDS="~amd64"
# This is currently tested via dev-python/blockbuster
# TODO: fix a subset of tests to work directly
RESTRICT="test"

#distutils_enable_tests pytest
