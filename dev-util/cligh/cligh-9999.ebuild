# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 git-r3

DESCRIPTION="Command-line interface to GitHub"
HOMEPAGE="http://the-brannons.com/software/cligh.html"
EGIT_REPO_URI="https://github.com/CMB/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
