# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="A configuration system for Python applications"
HOMEPAGE="https://github.com/ipython/traitlets"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${P}-python3_10.patch"
)

distutils_enable_sphinx docs/source \
	dev-python/ipython_genutils \
	dev-python/sphinx_rtd_theme
distutils_enable_tests pytest
