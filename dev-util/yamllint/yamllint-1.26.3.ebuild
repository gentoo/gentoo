# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: py310 - will officially be supported upstream from the next release
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A linter for YAML files"
HOMEPAGE="https://pypi.org/project/yamllint/ https://github.com/adrienverge/yamllint/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND=">=dev-python/pathspec-0.5.3[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
