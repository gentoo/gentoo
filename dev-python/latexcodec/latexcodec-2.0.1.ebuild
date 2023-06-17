# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Lexer and codec to work with LaTeX code in Python"
HOMEPAGE="https://github.com/mcmtroffaes/latexcodec/ https://pypi.org/project/latexcodec/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
