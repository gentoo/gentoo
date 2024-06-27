# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Library to parse gdb mi output and interact with gdb subprocesses"
HOMEPAGE="
	https://cs01.github.io/pygdbmi/
	https://github.com/cs01/pygdbmi/
	https://pypi.org/project/pygdbmi/
"
# no tests in sdist
SRC_URI="
	https://github.com/cs01/pygdbmi/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-debug/gdb-9.6
"

distutils_enable_tests pytest
