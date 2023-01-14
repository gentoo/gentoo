# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Local/remote mirroring+incremental backup"
HOMEPAGE="https://github.com/rdiff-backup/rdiff-backup"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
# Tests use a tox environment and separate steps for test env preparation
RESTRICT="test"

DEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	>=net-libs/librsync-1.0:0="

RDEPEND="dev-python/pylibacl[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]
	>=net-libs/librsync-1.0:0="

src_prepare() {
	sed -e "s#share/doc/${PN}#share/doc/${PF}#" -i setup.py || die
	default
}
