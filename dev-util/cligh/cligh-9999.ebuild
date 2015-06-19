# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cligh/cligh-9999.ebuild,v 1.4 2015/04/08 17:54:02 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )

inherit distutils-r1 git-2

DESCRIPTION="Command-line interface to GitHub"
HOMEPAGE="http://the-brannons.com/software/cligh.html"
EGIT_REPO_URI="git://github.com/CMB/cligh.git
	https://github.com/CMB/cligh.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/PyGithub[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
