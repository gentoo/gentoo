# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 git-r3

DESCRIPTION="Command-line interface to GitHub"
HOMEPAGE="https://the-brannons.com/software/cligh.html"
EGIT_REPO_URI="https://github.com/CMB/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

RDEPEND="dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"
