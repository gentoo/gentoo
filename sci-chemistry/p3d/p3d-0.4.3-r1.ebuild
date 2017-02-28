# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot versionator

MY_P="${PN}-$(replace_version_separator 3 -)"
GITHUB_ID="gb8b9a75"

DESCRIPTION="Python module for structural bioinformatics"
HOMEPAGE="http://p3d.fufezan.net/"
SRC_URI="https://nodeload.github.com/fu/${PN}/tarball/${PV} -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-3"
IUSE="examples"

src_install() {
	distutils-r1_src_install

	if use examples; then
		insinto /usr/share/${PN}
		doins -r pdbs exampleScripts
	fi
}
