# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3 versionator

DESCRIPTION="Python module for structural bioinformatics"
HOMEPAGE="http://p3d.fufezan.net/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/fu/p3d.git"

SLOT="0"
KEYWORDS=""
LICENSE="GPL-3"
IUSE="examples"

src_install() {
	distutils-r1_src_install

	if use examples; then
		insinto /usr/share/${PN}
		doins -r pdbs exampleScripts
	fi
}
