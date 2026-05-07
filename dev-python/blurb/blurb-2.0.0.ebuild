# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/python/blurb
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Tool to create and manage NEWS blurbs for CPython"
HOMEPAGE="
	https://github.com/python/blurb/
	https://pypi.org/project/blurb/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

EPYTEST_PLUGINS=( pyfakefs time-machine )
distutils_enable_tests pytest
