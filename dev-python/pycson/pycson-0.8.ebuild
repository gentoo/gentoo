# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1
DESCRIPTION="A python parser for the Coffeescript Object Notation (CSON)"
HOMEPAGE="https://github.com/avakar/pycson/"
SRC_URI="https://github.com/avakar/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~ppc x86"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/speg"
