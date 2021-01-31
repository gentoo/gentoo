# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Command-line interface to GitHub"
HOMEPAGE="https://the-brannons.com/software/cligh.html"
SRC_URI="https://the-brannons.com/software/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"
