# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

UPSTREAM_PV=$(replace_all_version_separators '-')

DESCRIPTION="Local/remote mirroring+incremental backup"
HOMEPAGE="https://github.com/sol1/rdiff-backup"
SRC_URI="https://github.com/sol1/${PN}/archive/r${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="examples"

DEPEND="
	net-libs/librsync:0/2
"
RDEPEND="
	dev-python/pyxattr[${PYTHON_USEDEP}]
	dev-python/pylibacl[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}-librsync-1.0.0.patch" )

python_install_all() {
	use examples && local EXAMPLES=( examples.html )

	distutils-r1_python_install_all
}
