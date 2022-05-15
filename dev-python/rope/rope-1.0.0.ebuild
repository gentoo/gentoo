# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python refactoring library"
HOMEPAGE="
	https://pypi.org/project/rope/
	https://github.com/python-rope/rope/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

BDEPEND="
	test? (
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
