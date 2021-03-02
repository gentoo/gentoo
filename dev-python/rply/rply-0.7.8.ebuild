# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Pure python parser generator that also works with RPython"
HOMEPAGE="https://github.com/alex/rply"
SRC_URI="https://github.com/alex/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/py[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
