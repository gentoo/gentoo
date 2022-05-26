# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="A python parser for the Coffeescript Object Notation (CSON)"
HOMEPAGE="https://github.com/avakar/pycson/"
SRC_URI="https://github.com/avakar/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86"

RDEPEND="dev-python/speg"

distutils_enable_tests pytest
