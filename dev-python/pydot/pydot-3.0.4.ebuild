# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python interface to Graphviz's Dot language"
HOMEPAGE="
	https://github.com/pydot/pydot/
	https://pypi.org/project/pydot/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/pyparsing-3.0.9[${PYTHON_USEDEP}]
	media-gfx/graphviz
"
BDEPEND="
	test? (
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest
