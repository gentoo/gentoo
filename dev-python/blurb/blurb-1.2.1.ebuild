# Copyright 2018-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Tool to create and manage NEWS blurbs for CPython"
HOMEPAGE="
	https://github.com/python/core-workflow/tree/master/blurb
	https://pypi.org/project/blurb/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	test? (
		dev-python/pyfakefs[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
