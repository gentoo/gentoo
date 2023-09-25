# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="A python parser for the Coffeescript Object Notation (CSON)"
HOMEPAGE="https://github.com/avakar/pycson/"
SRC_URI="https://github.com/avakar/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86"

RDEPEND="dev-python/speg[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
