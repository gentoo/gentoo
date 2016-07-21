# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"

inherit git-2 distutils versionator

DESCRIPTION="Python module for structural bioinformatics"
HOMEPAGE="http://p3d.fufezan.net/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/fu/p3d.git"

SLOT="0"
KEYWORDS=""
LICENSE="GPL-3"
IUSE="examples"

S="${WORKDIR}"/${PN}

src_install() {
	distutils_src_install
	if use examples; then
		insinto /usr/share/${PN}
		doins -r pdbs exampleScripts || die
	fi
}
