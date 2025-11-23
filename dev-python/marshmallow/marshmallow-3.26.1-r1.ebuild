# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="A library for converting to and from native Python datatypes"
HOMEPAGE="
	https://github.com/marshmallow-code/marshmallow/
	https://pypi.org/project/marshmallow/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-python/packaging-17.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/simplejson[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
