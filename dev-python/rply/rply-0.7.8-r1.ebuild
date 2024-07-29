# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Pure python parser generator that also works with RPython"
HOMEPAGE="
	https://github.com/alex/rply/
	https://pypi.org/project/rply/
"
SRC_URI="
	https://github.com/alex/rply/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/py[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs
