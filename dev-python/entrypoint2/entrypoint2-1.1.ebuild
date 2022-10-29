# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Easy to use command-line interface for python modules"
HOMEPAGE="https://github.com/ponty/entrypoint2"
SRC_URI="
	https://github.com/ponty/entrypoint2/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~riscv x86"

BDEPEND="
	test? (
		dev-python/easyprocess[${PYTHON_USEDEP}]
		dev-python/path[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
